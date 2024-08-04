# Bicycle Shop Backend

## Problem Statement

[Bicycle Shop (Marcus Store) - Description](https://gist.github.com/kunaldhyani026/e3fc97f4d78da08d75533bf8f48ebba5)
## Running the Application
### Prerequisites
Make sure you have Docker installed on your system. You can download and install Docker from [here](https://www.docker.com/get-started).
### Setting up the Application / Deploy using docker images
- Pull the docker image:
  ```
  to-do
  ```
- Run the container:
  ```
  to-do
  ```
- to-do

### Test Pipeline
- to-do


### Database Design 
[View in Editor](https://dbdiagram.io/d/factorial-backend-erd-66a654028b4bb5230e8dd8fb)
![factorial-backend-erd](https://github.com/user-attachments/assets/4d7f3867-e812-4d2d-9ef7-ae20e5a9bda8)

### Deep Dive in Data Model

#### `customers` Table
- **Meaning**: Represents a customer in the system, with unique contact details.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the customer.
  - `name` (varchar): Customer's name.
  - `email` (varchar, unique, not null): Customer's email address.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Indexes**:
  - `email` (unique): Ensures that each email address is unique across customers.
- **Associations**:
  - `carts`: One-to-One relationship; a customer can have only one cart.

#### `carts` Table
- **Meaning**: Represents a shopping cart belonging to a specific customer, tracking the total cost and its items.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the cart.
  - `customer_id` (int, FK): References `customers.id`; identifies to which customer this cart belongs to.
  - `total` (decimal, default: 0): Total value of the cart.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Associations**:
  - `customer` (belongs to `customers`).
  - `cart_items`: One-to-many relationship; a cart can contain multiple items.

#### `cart_items` Table
- **Meaning**: Represents an item within a cart, including the product details.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the cart item.
  - `cart_id` (int, FK): References `carts.id`; identifies the cart to which the item belongs.
  - `product_id` (int, FK): References `products.id`; identifies the product in the cart item.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Associations**:
  - `cart` (belongs to `carts`).
  - `product` (belongs to `products`).
  - _`cart_items_customizable_options` (join table) : Many-to-many relationship with `customizable_options`._

#### `products` Table
- **Meaning**: Represents a product available for purchase, with a unique name.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the product.
  - `name` (varchar, unique): Name of the product.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Indexes**:
  - `name` (unique): Ensures that each product name is unique.
- **Associations**:
  - `cart_items`: One-to-many relationship; a product can be part of multiple cart items.
  - _`products_customizable_options` (join table): Many-to-many relationship with `customizable_options`_
  
#### `customizables` Table
- **Meaning**: Represents a category of customizable (e.g., Frame Type, Wheels).
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the customizable.
  - `name` (varchar, unique): Name of the customizable (e.g., Frame Type, Wheels).
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Indexes**:
  - `name` (unique): Ensures that each customizable name is unique.
- **Associations**:
  - `customizable_options`: One-to-many relationship; each customizable has multiple options.

#### `customizable_options` Table
- **Meaning**: Represents a specific option for a customizable, including its price and stock status.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the customizable option.
  - `name` (varchar): Name of the customizable option (e.g., red, large).
  - `price` (decimal, default: 0): Price associated with this option.
  - `stock` (bool, default: true): Availability status of the option.
  - `customizable_id` (int, FK): References `customizables.id`; identifies to which customizable this option belongs to.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Indexes**:
  - `(customizable_id, name)` (unique): Ensures that each customizable option name is unique within its customizable.
- **Associations**:
  - `customizable` (belongs to `customizables`).
  - `prohibitions`: One-to-many relationship; an option can have prohibitions.
  - _`products_customizable_options` (join table): Many-to-many relationship with `products`._
  - _`cart_items_customizable_options` (join table): Many-to-many relationship with `cart_items`._

#### `prohibitions` Table
- **Meaning**: Defines which combinations of customizable options are prohibited.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the prohibition record.
  - `customizable_option_id` (int, FK): References `customizable_options.id`; the option whose selection prohibits other options.
  - `prohibited_customizable_option_id` (int, FK): References `customizable_options.id`; the option which gets prohibited.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Indexes**:
  - `(customizable_option_id, prohibited_customizable_option_id)` (unique): Ensures unique prohibition pairs.
  - `(prohibited_customizable_option_id, customizable_option_id)` (unique): Ensures unique prohibition pairs in reverse.
  - `CHECK (customizable_option_id <> prohibited_customizable_option_id);` : Ensures both columns cannot have the same value.
- **Associations**:
  - `customizable_option` (belongs to `customizable_options` as the option whose selection restricts other options).
  - `prohibited_customizable_option` (belongs to `customizable_options` as the option which gets prohibited).

#### `products_customizable_options` JOIN Table
- **Meaning**: Associates products with their available customizable options.
- **Fields**:
  - `product_id` (int, FK): References `products.id`; identifies the product.
  - `customizable_option_id` (int, FK): References `customizable_options.id`; identifies the customizable option for the product.
- **Indexes**:
  - `(product_id, customizable_option_id)` (unique): Ensures that each product-customizable option pair is unique.
- **Associations**:
  - `product` (belongs to `products`).
  - `customizable_option` (belongs to `customizable_options`).

#### `cart_items_customizable_options` JOIN Table
- **Meaning**: Manages the customizable options selected for a specific cart item.
- **Fields**:
  - `cart_item_id` (int, FK): References `cart_items.id`; identifies the cart item.
  - `customizable_option_id` (int, FK): References `customizable_options.id`; identifies the customizable option for the cart item.
- **Indexes**:
  - `(cart_item_id, customizable_option_id)` (unique): Ensures that each cart item-customizable option pair is unique.
- **Associations**:
  - `cart_item` (belongs to `cart_items`).
  - `customizable_option` (belongs to `customizable_options`).

#### `pricing_groups` Table
- **Meaning**: Represents different pricing strategies or groups that can be applied to customizable options.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the pricing group.
  - `name` (varchar, not null): Name of the pricing group.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Associations**:
  - _`pricing_groups_customizable_options` (join table): Many-to-many relationship with `customizable_options`._
  - `customizable_option_price_by_group`: One-to-many relationship; a pricing group can be associated with multiple customizable_option with specific prices.

#### `pricing_groups_customizable_options` JOIN Table
- **Meaning**: Associates customizable options with specific pricing groups.
- **Fields**:
  - `pricing_group_id` (int, FK): References `pricing_groups.id`; identifies the pricing group.
  - `customizable_option_id` (int, FK): References `customizable_options.id`; identifies the customizable option within the pricing group.
- **Indexes**:
  - `(pricing_group_id, customizable_option_id)` (unique): Ensures that each pricing group-customizable option pair is unique.
- **Associations**:
  - `pricing_group` (belongs to `pricing_groups`).
  - `customizable_option` (belongs to `customizable_options`).

#### `customizable_option_price_by_group` Table
- **Meaning**: Manages specific prices for customizable options based on the pricing group.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the price record.
  - `customizable_option_id` (int, FK): References `customizable_options.id`; identifies the customizable option.
  - `pricing_group_id` (int, FK): References `pricing_groups.id`; identifies the pricing group.
  - `price` (decimal(10, 2), not null): Price of the customizable option within the pricing group.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Associations**:
  - `customizable_option` (belongs to `customizable_options`).
  - `pricing_group` (belongs to `pricing_groups`).


### Description of main user actions

- #### The Home Page
  This page shows all the products available for user to purchase.
  - API
    - Request : GET - /products
    - Response :
      ```
      [
          {
              "id": 1,
              "name": "Bicycle",
              "description": "Customize your bicycle"
          },
          {
              "id": 2,
              "name": "Surfboard",
              "description": "Customize your surfboard"
          }
      ]
      ```
  - UI
    ![image](https://github.com/user-attachments/assets/568b0482-5d0c-46f8-a5ea-859c69b73abe)
      
- #### The Product Page
  Upon click on individual product from home page, the product page gets loaded. This page has all the info related to available customizables, their customizable_options, stock availability and prohibited combinations.
  
  - API
    - Request : GET - /products/:id (/products/1)
    - Response :
      ```
      {
          "product": {
              "id": 1,
              "name": "Bicycle",
              "description": "Customize your bicycle"
          },
          "customizables": [
              {
                  "id": 1,
                  "name": "Frame Type"
              },
              {
                  "id": 2,
                  "name": "Frame Finish"
              },
              {
                  "id": 3,
                  "name": "Wheels"
              },
              {
                  "id": 4,
                  "name": "Rim Color"
              },
              {
                  "id": 5,
                  "name": "Chain"
              }
          ],
          "customizable_options": {
              "Frame Type": [
                  {
                      "id": 1,
                      "name": "Full Suspension",
                      "price": 300.0,
                      "stock": true,
                      "prohibited_combinations": []
                  },
                  {
                      "id": 2,
                      "name": "Diamond",
                      "price": 150.0,
                      "stock": true,
                      "prohibited_combinations": [7]
                  },
                  {
                      "id": 3,
                      "name": "step-through",
                      "price": 100.0,
                      "stock": true,
                      "prohibited_combinations": [7]
                  }
              ],
              "Frame Finish": [
                  {
                      "id": 4,
                      "name": "Matte",
                      "price": 40.0,
                      "stock": true,
                      "prohibited_combinations": []
                  },
                  {
                      "id": 5,
                      "name": "Shiny",
                      "price": 30.0,
                      "stock": true,
                      "prohibited_combinations": []
                  }
              ],
              "Wheels": [
                  {
                      "id": 6,
                      "name": "Road Wheels",
                      "price": 100.0,
                      "stock": true,
                      "prohibited_combinations": []
                  },
                  {
                      "id": 7,
                      "name": "Mountain Wheels",
                      "price": 200.0,
                      "stock": true,
                      "prohibited_combinations": [2,3]
                  },
                  {
                      "id": 8,
                      "name": "Fat Bike Wheels",
                      "price": 300.0,
                      "stock": true,
                      "prohibited_combinations": [10]
                  }
              ],
              "Rim Color": [
                  {
                      "id": 10,
                      "name": "Red",
                      "price": 10.0,
                      "stock": true,
                      "prohibited_combinations": [8]
                  },
                  {
                      "id": 11,
                      "name": "Blue",
                      "price": 20.0,
                      "stock": true,
                      "prohibited_combinations": []
                  },
                  {
                      "id": 12,
                      "name": "Black",
                      "price": 5.0,
                      "stock": false,
                      "prohibited_combinations": []
                  }
              ],
              "Chain": [
                  {
                      "id": 13,
                      "name": "Single-speed chain",
                      "price": 150.0,
                      "stock": true,
                      "prohibited_combinations": []
                  },
                  {
                      "id": 14,
                      "name": "8-speed chain",
                      "price": 400.0,
                      "stock": true,
                      "prohibited_combinations": []
                  }
              ]
          }
      }
      ```
  - UI
    ![image](https://github.com/user-attachments/assets/28a1e785-c89a-4f80-9063-392eedffa3dd)
    Prohibited Combination (Mountain Wheels only allowed with Full Suspension Frame)             |  Out of stock (Black Rim Color)
    :-------------------------:|:-------------------------:
    ![Screenshot (356)](https://github.com/user-attachments/assets/a64f87c3-75a1-4eef-b7ca-7776a11d908f) |  ![Screenshot (357)](https://github.com/user-attachments/assets/f991a129-e080-43af-8685-4fe14412a1c9)

- #### Add to Cart
  Upon making selection for customizables for a product on product page, user clicks on `Add to Cart` button, which adds item to the user's cart. When an item is added to the cart, all the available pricing (including special pricing based on other selected customizable options) are calculated and saved as total with the user's cart in carts table.

  Eg : Suppose user made following selections for **Bicycle customizable_options** :
  ``` Frame Type :  { id: 1, name: Full Suspension}, Frame Finish : { id: 4, name: Matte} , Wheels : { id: 7, name: Mountain Wheels} , Rim Color : { id: 10, name: Red }, Chain : { id: 13, name: Single-speed chain} ```
  - API
    - Request : POST - /carts/add_item
    - Payload :
      ```
        {
          "product_id" : 1,
          "customizable_options" : [1,4,7,10,13]
        }
      ```
    - Response : 201 Created
      ```
        { "cart_item_id" : 1}
      ```
    - Following things are persisted in the database
      - `carts`
        | id | total | customer_id | created_at                  | updated_at                  |
        |----|-------|-------------|-----------------------------|-----------------------------|
        | 1  | 710.0 | 1           | 2024-08-04 11:50:54.293513  | 2024-08-04 11:50:54.514518  |
      - `cart_items`
        | id | cart_id | product_id | created_at                  | updated_at                  |
        |----|---------|------------|-----------------------------|-----------------------------|
        | 1  | 1       | 1          | 2024-08-04 11:50:54.396087  | 2024-08-04 11:50:54.396087  |
      - `cart_items_customizable_options`
        | cart_item_id | customizable_option_id |
        |--------------|------------------------|
        | 1            | 1                      |
        | 1            | 4                      |
        | 1            | 7                      |
        | 1            | 10                     |
        | 1            | 13                     |

      - Every time an item is added to the cart, the cart's total gets updated accordingly. The total price calculation takes care of any special price (such as Finish Matte will cost higher for Full Suspension frame).

- #### View Cart
  - API
    - Authentication : Uses a JWT token for user info, but to keep things light-weight for now server is simplified with a hardcoded customer_id: 1 for all requests.
    - Request : GET - /carts
    - Response :
      ```
        {
          "cart": {
              "cart_items": [
                  {
                      "id": 1,
                      "product": "Bicycle",
                      "customizable_options": [
                          {
                              "id": 1,
                              "name": "Full Suspension",
                              "price": 300.0,
                              "customizable_name": "Frame Type"
                          },
                          {
                              "id": 4,
                              "name": "Matte",
                              "price": 50.0,
                              "customizable_name": "Frame Finish"
                          },
                          {
                              "id": 7,
                              "name": "Mountain Wheels",
                              "price": 200.0,
                              "customizable_name": "Wheels"
                          },
                          {
                              "id": 10,
                              "name": "Red",
                              "price": 10.0,
                              "customizable_name": "Rim Color"
                          },
                          {
                              "id": 13,
                              "name": "Single-speed chain",
                              "price": 150.0,
                              "customizable_name": "Chain"
                          }
                      ]
                  },
                  {
                      "id": 2,
                      "product": "Bicycle",
                      "customizable_options": [
                          {
                              "id": 2,
                              "name": "Diamond",
                              "price": 150.0,
                              "customizable_name": "Frame Type"
                          },
                          {
                              "id": 4,
                              "name": "Matte",
                              "price": 40.0,
                              "customizable_name": "Frame Finish"
                          },
                          {
                              "id": 6,
                              "name": "Road Wheels",
                              "price": 100.0,
                              "customizable_name": "Wheels"
                          },
                          {
                              "id": 10,
                              "name": "Red",
                              "price": 10.0,
                              "customizable_name": "Rim Color"
                          },
                          {
                              "id": 13,
                              "name": "Single-speed chain",
                              "price": 150.0,
                              "customizable_name": "Chain"
                          }
                      ]
                  }
              ],
              "total": 1160.0
          }
      }
      ```
  - UI
    
    Notice how `Matte Finish` Price is `40 Euros` for `Diamond Frame` and `50 Euros` for `Full Suspension Frame`. The API calculates the cost considering all the pricing (inidivual as well as the special pricing based on combinations of other selection.) In case of multiple special pricing applicable on a option, the one with the max price is considered so as Marcus is benefitted.
    
    ![image](https://github.com/user-attachments/assets/c051a298-edb4-4412-9bdd-5c6f36839036)

      

### Optimisations
to-do

### Configurations
to-do

### Observations, Assumptions and Points
to-do

### Suggestions and Future Iterations
to-do audit_trails

### Testing
