# Bicycle Shop Backend

## Problem Statement

[Bicycle Shop (Marcus Store) - Description](https://gist.github.com/kunaldhyani026/e3fc97f4d78da08d75533bf8f48ebba5)
## Running the Application
### Prerequisites
Make sure you have Docker installed on your system. You can download and install Docker from [here](https://www.docker.com/get-started).
### Setting up the Application / Deploy using docker images
- Pull the docker image:
  ```
  docker pull kunaldhyani026/factorial-backend-image
  ```
- Run the container:
  ```
  docker run -p 4000:4000 --name factorial-backend-container -d kunaldhyani026/factorial-backend-image
  ```
- APIs accessible at `http://localhost:4000/` [Use postman or cURL to hit JSON API requests] or use [Biycle Frontend App](https://github.com/kunaldhyani026/factorial-frontend)
  #### Test Pipeline
  - To run the specs:
     - Login to container: `docker exec -it factorial-backend-container bash`
     - Run: `rspec`


### Important Note
This backend rails API service is developed to work with [Bicycle Shop Frontend Repository](https://github.com/kunaldhyani026/factorial-frontend)


## Database Design 
[View in Editor](https://dbdiagram.io/d/factorial-backend-erd-66a654028b4bb5230e8dd8fb)
![factorial-backend-erd](https://github.com/user-attachments/assets/4d7f3867-e812-4d2d-9ef7-ae20e5a9bda8)

<hr/>

## Deep Dive in Data Model

### `customers` Table
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

### `carts` Table
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

### `cart_items` Table
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

### `products` Table
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
  
### `customizables` Table
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

### `customizable_options` Table
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

### `prohibitions` Table
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

### `products_customizable_options` JOIN Table
- **Meaning**: Associates products with their available customizable options.
- **Fields**:
  - `product_id` (int, FK): References `products.id`; identifies the product.
  - `customizable_option_id` (int, FK): References `customizable_options.id`; identifies the customizable option for the product.
- **Indexes**:
  - `(product_id, customizable_option_id)` (unique): Ensures that each product-customizable option pair is unique.
- **Associations**:
  - `product` (belongs to `products`).
  - `customizable_option` (belongs to `customizable_options`).

### `cart_items_customizable_options` JOIN Table
- **Meaning**: Manages the customizable options selected for a specific cart item.
- **Fields**:
  - `cart_item_id` (int, FK): References `cart_items.id`; identifies the cart item.
  - `customizable_option_id` (int, FK): References `customizable_options.id`; identifies the customizable option for the cart item.
- **Indexes**:
  - `(cart_item_id, customizable_option_id)` (unique): Ensures that each cart item-customizable option pair is unique.
- **Associations**:
  - `cart_item` (belongs to `cart_items`).
  - `customizable_option` (belongs to `customizable_options`).

### `pricing_groups` Table
- **Meaning**: Represents different pricing strategies or groups that can be applied to customizable options.
- **Fields**:
  - `id` (int, PK, auto-increment): Unique identifier for the pricing group.
  - `name` (varchar, not null): Name of the pricing group.
  - `created_at` (timestamp): Record creation timestamp.
  - `updated_at` (timestamp): Last update timestamp.
- **Associations**:
  - _`pricing_groups_customizable_options` (join table): Many-to-many relationship with `customizable_options`._
  - `customizable_option_price_by_group`: One-to-many relationship; a pricing group can be associated with multiple customizable_option with specific prices.

### `pricing_groups_customizable_options` JOIN Table
- **Meaning**: Associates customizable options with specific pricing groups.
- **Fields**:
  - `pricing_group_id` (int, FK): References `pricing_groups.id`; identifies the pricing group.
  - `customizable_option_id` (int, FK): References `customizable_options.id`; identifies the customizable option within the pricing group.
- **Indexes**:
  - `(pricing_group_id, customizable_option_id)` (unique): Ensures that each pricing group-customizable option pair is unique.
- **Associations**:
  - `pricing_group` (belongs to `pricing_groups`).
  - `customizable_option` (belongs to `customizable_options`).

### `customizable_option_price_by_group` Table
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

<br>
<hr/>

## Description of main user actions

- ### The Home Page
  This page shows all the products available for user to purchase.
  - #### API
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
  - #### UI
    ![image](https://github.com/user-attachments/assets/568b0482-5d0c-46f8-a5ea-859c69b73abe)
      
- ### The Product Page
  Upon click on individual product from home page, the product page gets loaded. This page has all the info related to available customizables, their customizable_options, stock availability and prohibited combinations.
  
  - #### API
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
  - #### UI
    ![image](https://github.com/user-attachments/assets/28a1e785-c89a-4f80-9063-392eedffa3dd)
    
    Prohibited Combination (Mountain Wheels only allowed with Full Suspension Frame)             |  Out of stock (Black Rim Color)
    :-------------------------:|:-------------------------:
    ![Screenshot (356)](https://github.com/user-attachments/assets/a64f87c3-75a1-4eef-b7ca-7776a11d908f) |  ![Screenshot (357)](https://github.com/user-attachments/assets/f991a129-e080-43af-8685-4fe14412a1c9)

- ### Add to Cart
  Upon making selection for customizables for a product on product page, user clicks on `Add to Cart` button, which adds item to the user's cart. When an item is added to the cart, all the available pricing (including special pricing based on other selected customizable options) are calculated and saved as total with the user's cart in carts table.

  Eg : Suppose user made following selections for **Bicycle customizable_options** :
  ``` Frame Type :  { id: 1, name: Full Suspension}, Frame Finish : { id: 4, name: Matte} , Wheels : { id: 7, name: Mountain Wheels} , Rim Color : { id: 10, name: Red }, Chain : { id: 13, name: Single-speed chain} ```
  - #### API
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
  - #### Things persisted in database
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

- ### View Cart
  - #### API
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
  - #### UI
    
    Notice how `Matte Finish` Price is `40 Euros` for `Diamond Frame` and `50 Euros` for `Full Suspension Frame`. The API calculates the cost considering all the pricing (individual as well as the special pricing based on combinations of other selection.) In case of multiple special pricing applicable on a option, the one with the max price is considered so as Marcus is benefitted.
    
    ![image](https://github.com/user-attachments/assets/c051a298-edb4-4412-9bdd-5c6f36839036)

<br>
<hr/>

##  The description of the main workflows from the administration part of the website, where Marcus configures the store
   Currently to keep things light-weight, no authentication and authorization is setup. Going forward we can it up, so that only authorized users can access admin portal.
  - ### Admin Landing Page
    - #### UI
      ![image](https://github.com/user-attachments/assets/9557c25a-a8d5-4e0b-aa19-26a0367a33eb)

  - ### Creation of new product
    Upon clicking on `Add new Product` from admin home page, following page is loaded where admin can add a new product for its store along with what all customizables that can be done on that product.

    - #### API (to drive the UI)
      - Request : GET - /customizable_options
      - Response :
        ```
          {
            "products": [
                {
                    "id": 1,
                    "name": "Bicycle"
                },
                {
                    "id": 2,
                    "name": "Surfboard"
                }
            ],
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
            "customizable_options": [
                {
                    "id": 1,
                    "customizable_id": 1,
                    "name": "Full Suspension",
                    "price": 300.0,
                    "stock": true
                },
                {
                    "id": 2,
                    "customizable_id": 1,
                    "name": "Diamond",
                    "price": 150.0,
                    "stock": true
                },
                {
                    "id": 3,
                    "customizable_id": 1,
                    "name": "step-through",
                    "price": 100.0,
                    "stock": true
                },
                {
                    "id": 4,
                    "customizable_id": 2,
                    "name": "Matte",
                    "price": 40.0,
                    "stock": true
                },
                {
                    "id": 5,
                    "customizable_id": 2,
                    "name": "Shiny",
                    "price": 30.0,
                    "stock": true
                },
                {
                    "id": 6,
                    "customizable_id": 3,
                    "name": "Road Wheels",
                    "price": 100.0,
                    "stock": true
                },
                {
                    "id": 7,
                    "customizable_id": 3,
                    "name": "Mountain Wheels",
                    "price": 200.0,
                    "stock": true
                },
                {
                    "id": 8,
                    "customizable_id": 3,
                    "name": "Fat Bike Wheels",
                    "price": 300.0,
                    "stock": true
                },
                {
                    "id": 9,
                    "customizable_id": 3,
                    "name": "Non-Rusty Tiny Wheels",
                    "price": 120.0,
                    "stock": true
                },
                {
                    "id": 10,
                    "customizable_id": 4,
                    "name": "Red",
                    "price": 10.0,
                    "stock": true
                },
                {
                    "id": 11,
                    "customizable_id": 4,
                    "name": "Blue",
                    "price": 20.0,
                    "stock": true
                },
                {
                    "id": 12,
                    "customizable_id": 4,
                    "name": "Black",
                    "price": 5.0,
                    "stock": false
                },
                {
                    "id": 13,
                    "customizable_id": 5,
                    "name": "Single-speed chain",
                    "price": 150.0,
                    "stock": true
                },
                {
                    "id": 14,
                    "customizable_id": 5,
                    "name": "8-speed chain",
                    "price": 400.0,
                    "stock": true
                }
            ]
        }
        ```
    - #### UI
      UI             |  UI Validations
      :-------------------------:|:-------------------------:
      ![image](https://github.com/user-attachments/assets/d98e3d77-def2-489f-871d-92b9e985c666) |  ![image](https://github.com/user-attachments/assets/69cd87f4-b450-43c1-8139-4b2080db87f8)

    - #### Add Product button click
      
      Suppose admin added a new product `Golf Cart`. And only customizable for these are Wheels and Chains.
      User added - `Golf Cart, allowed customizable_options -  Wheels : { id: 9, name: Non-Rusty Tiny Wheels }, Chain : { id: 13, name: Single-speed chain}, {id: 14, naem: 8-speed chain}`
      - ##### API
        - Request : POST - /products
        - Payload :
          ```
            {
              "product_name" : "Golf Cart",
              "product_description" : "Customize your golf cart",
              "customizable_options" : [9,13,14]
            }
          ```
        - Response : 201 Created
          ```
            {
                "id": 3,
                "name": "Golf Cart",
                "description": "Customize your golf cart",
                "created_at": "2024-08-04T13:33:30.002Z",
                "updated_at": "2024-08-04T13:33:30.002Z"
            }
          ```
      - ##### Things persisted in the database
        - `products` table
          | id | name       | description              | created_at                  | updated_at                  |
          |----|------------|--------------------------|-----------------------------|-----------------------------|
          | 1  | Bicycle    | Customize your bicycle   | 2024-08-04 11:22:27.069546  | 2024-08-04 11:22:27.069546  |
          | 2  | Surfboard  | Customize your surfboard | 2024-08-04 11:22:27.099764  | 2024-08-04 11:22:27.099764  |
          | 3  | Golf Cart  | Customize your golf cart | 2024-08-04 13:33:30.002426  | 2024-08-04 13:33:30.002426  |

        - `products_customizable_options` table
          | product_id | customizable_option_id |
          |------------|-------------------------|
          | .....      | ...........             |
          | .....      | .....existing entries   |
          | 3          | 9                       |
          | 3          | 13                      |
          | 3          | 14                      |

        - This is how the Home page UI looks like now -
          ![image](https://github.com/user-attachments/assets/0c659dd5-6c02-40f7-8e4f-c467f2d79c18)

  - ### Addition of a new part choice
    Upon clicking on `Add new Customizable Option` from admin home page, following page is loaded where admin can add a customizable option, along with mapping that to which Product(s) this option should be allowed.

    - #### API (to drive the UI)
      - Request : GET - /customizable_options
      - Response :
        ```
          {
            "products": [
                {
                    "id": 1,
                    "name": "Bicycle"
                },
                {
                    "id": 2,
                    "name": "Surfboard"
                },
                {
                    "id": 3,
                    "name": "Golf Cart"
                }
            ],
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
            "customizable_options": [
                {
                    "id": 1,
                    "customizable_id": 1,
                    "name": "Full Suspension",
                    "price": 300.0,
                    "stock": true
                },
                {
                    "id": 2,
                    "customizable_id": 1,
                    "name": "Diamond",
                    "price": 150.0,
                    "stock": true
                },
                {
                    "id": 3,
                    "customizable_id": 1,
                    "name": "step-through",
                    "price": 100.0,
                    "stock": true
                },
                {
                    "id": 4,
                    "customizable_id": 2,
                    "name": "Matte",
                    "price": 40.0,
                    "stock": true
                },
                {
                    "id": 5,
                    "customizable_id": 2,
                    "name": "Shiny",
                    "price": 30.0,
                    "stock": true
                },
                {
                    "id": 6,
                    "customizable_id": 3,
                    "name": "Road Wheels",
                    "price": 100.0,
                    "stock": true
                },
                {
                    "id": 7,
                    "customizable_id": 3,
                    "name": "Mountain Wheels",
                    "price": 200.0,
                    "stock": true
                },
                {
                    "id": 8,
                    "customizable_id": 3,
                    "name": "Fat Bike Wheels",
                    "price": 300.0,
                    "stock": true
                },
                {
                    "id": 9,
                    "customizable_id": 3,
                    "name": "Non-Rusty Tiny Wheels",
                    "price": 120.0,
                    "stock": true
                },
                {
                    "id": 10,
                    "customizable_id": 4,
                    "name": "Red",
                    "price": 10.0,
                    "stock": true
                },
                {
                    "id": 11,
                    "customizable_id": 4,
                    "name": "Blue",
                    "price": 20.0,
                    "stock": true
                },
                {
                    "id": 12,
                    "customizable_id": 4,
                    "name": "Black",
                    "price": 5.0,
                    "stock": false
                },
                {
                    "id": 13,
                    "customizable_id": 5,
                    "name": "Single-speed chain",
                    "price": 150.0,
                    "stock": true
                },
                {
                    "id": 14,
                    "customizable_id": 5,
                    "name": "8-speed chain",
                    "price": 400.0,
                    "stock": true
                }
            ]
        }
        ```
  
    - #### UI
      UI             |  UI Validations
      :-------------------------:|:-------------------------:
      ![image](https://github.com/user-attachments/assets/250693d1-c80a-429c-8f25-f3003971533a) | ![image](https://github.com/user-attachments/assets/8385558f-6f27-4898-9aae-259a410cec25)
  
    - #### Add Option button click
    
      Suppose admin added a new customizable option `Tiny Grass Wheels` for the `Wheels` customizable, Price : 400 Euro, In Stock : No.

      Admin also selected only applicable products - `Golf Cart`. This is obvious as admin don't want a `Tiny Grass Wheels` customizable option available for `Bicycle's Wheels customization`.

      User added - `customizable_option : 'Tiny Grass Wheels' for customizable : {id: 3, name: Wheels}, Price: 400 Euros, Stock Status: False, Applicable Products : {id: 3, name: Golf Cart}`

      - ##### API
        - Request : POST - /customizable_options
        - Payload :
          ```
          {
            "name": "Tiny Grass Wheels",
            "price" : "400",
            "in_stock" : false,
            "customizable_id" : 3,
            "product_ids": [3]
          }
          ```
        - Response : 201 Created
          ```
            {
                "id": 15,
                "name": "Tiny Grass Wheels",
                "customizable_id": 3,
                "price": 400.0,
                "stock": false,
                "created_at": "2024-08-04T15:06:53.704Z",
                "updated_at": "2024-08-04T15:06:53.704Z"
            }
          ```
      - ##### Things persisted in the database
        - `customizable_options` table
          | id | name            | customizable_id | price | stock | created_at                  | updated_at                  |
          |----|-----------------|-----------------|-------|-------|-----------------------------|-----------------------------|
          | .. | .....           | .....           | ..    | ..    | .........                   | ......existing entries      |
          | 15 | Tiny Grass Wheels| 3              | 400.0 | false | 2024-08-04 15:06:53.704276  | 2024-08-04 15:06:53.704276  |

        - `products_customizable_options` table
          | product_id | customizable_option_id |
          |------------|-------------------------|
          | .....      | ...........             |
          | .....      | .....existing entries   |
          | 3 //existing          | 9 //existing                       |
          | 3 //existing          | 13 //existing                      |
          | 3 //existing         | 14  //existing                    |
          | 3          | 15                      |

        - This is how product page UI looks like now
          Bicycle (Tiny Grass Wheels not available under Wheels customizable options)             |  Golf Cart (Tiny Grass Wheels available under Wheels customizable )
          :-------------------------:|:-------------------------:
          ![Screenshot (360)](https://github.com/user-attachments/assets/29c98fa6-971f-4d6b-976e-45a88bad5d22) | ![Screenshot (361)](https://github.com/user-attachments/assets/a098634e-819c-4460-ae40-71619d0152ef)


  - ### Setting Up Prices
    Upon clicking on `Modify Customizable Options` from admin home page, following page is loaded where admin can modify a customizable option or define special pricing based on customizable option combinations.
    - #### API (to drive the UI)
      - Request : GET - /customizable_options
      - Response :
        ```
          {
            "products": [
                {
                    "id": 1,
                    "name": "Bicycle"
                },
                {
                    "id": 2,
                    "name": "Surfboard"
                },
                {
                    "id": 3,
                    "name": "Golf Cart"
                }
            ],
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
            "customizable_options": [
                {
                    "id": 1,
                    "customizable_id": 1,
                    "name": "Full Suspension",
                    "price": 300.0,
                    "stock": true
                },
                {
                    "id": 2,
                    "customizable_id": 1,
                    "name": "Diamond",
                    "price": 150.0,
                    "stock": true
                },
                {
                    "id": 3,
                    "customizable_id": 1,
                    "name": "step-through",
                    "price": 100.0,
                    "stock": false
                },
                {
                    "id": 4,
                    "customizable_id": 2,
                    "name": "Matte",
                    "price": 40.0,
                    "stock": true
                },
                {
                    "id": 5,
                    "customizable_id": 2,
                    "name": "Shiny",
                    "price": 30.0,
                    "stock": true
                },
                {
                    "id": 6,
                    "customizable_id": 3,
                    "name": "Road Wheels",
                    "price": 100.0,
                    "stock": true
                },
                {
                    "id": 7,
                    "customizable_id": 3,
                    "name": "Mountain Wheels",
                    "price": 200.0,
                    "stock": true
                },
                {
                    "id": 8,
                    "customizable_id": 3,
                    "name": "Fat Bike Wheels",
                    "price": 300.0,
                    "stock": true
                },
                {
                    "id": 9,
                    "customizable_id": 3,
                    "name": "Non-Rusty Tiny Wheels",
                    "price": 120.0,
                    "stock": true
                },
                {
                    "id": 10,
                    "customizable_id": 4,
                    "name": "Red",
                    "price": 10.0,
                    "stock": true
                },
                {
                    "id": 11,
                    "customizable_id": 4,
                    "name": "Blue",
                    "price": 20.0,
                    "stock": true
                },
                {
                    "id": 12,
                    "customizable_id": 4,
                    "name": "Black",
                    "price": 5.0,
                    "stock": false
                },
                {
                    "id": 13,
                    "customizable_id": 5,
                    "name": "Single-speed chain",
                    "price": 150.0,
                    "stock": true
                },
                {
                    "id": 14,
                    "customizable_id": 5,
                    "name": "8-speed chain",
                    "price": 400.0,
                    "stock": true
                },
                {
                    "id": 15,
                    "customizable_id": 3,
                    "name": "Tiny Grass Wheels",
                    "price": 400.0,
                    "stock": false
                }
            ]
        }
        ```
    
    - #### UI
      ![image](https://github.com/user-attachments/assets/c1dae955-da69-43fa-9322-c41fba083cf3)

    - #### Modify button Click
      - ##### UI
        ![image](https://github.com/user-attachments/assets/8b4a8d00-851a-443f-958b-85f56c1c410e)
      
      From this UI, Suppose Admin changed the price of Full Suspension from `300 Euro` to `500 Euro`.

      - ##### API
        - Request : PATCH - /customizable_options/:id  (/customizable_options/1)
        - Payload : ` { price : 500 } `
        - Response : 204 No Content

      - ##### Things persisted in the database
        - `customizable_options` table
          | id | name            | customizable_id | price | stock | created_at                  | updated_at                  |
          |----|-----------------|-----------------|-------|-------|-----------------------------|-----------------------------|
          | 1  | Full Suspension | 1               | 300.0 --> 500.00 | true | 2024-08-04 11:22:27.329730  | 2024-08-04 16:09:07.336495  |
            

    - #### Add Special Price Button click
      - ##### UI
        ![image](https://github.com/user-attachments/assets/12c9f523-ff5e-4110-a3c3-39a5656e6d33)

        From this UI, suppose admin added a special price of `60 Euros` for customizable option `Red Rim Color {id: 10}` when other customizable option combinations are - `Diamond Frame Type {id: 2}` and `Shiny Frame Finish {id: 5}`
   
        <img src="https://github.com/user-attachments/assets/5aba0983-67d1-4cf1-8b11-45d984c2051a" width="800" height="500">

      - ##### API
        - Request : POST - /pricing_groups
        - Payload :
          ```
            {
              "pricing_group_name" : "Red Rim Color Special Price",
              "customizable_option_id": 10
              "price": 60,
              "customizable_option_combinations": [2, 5]
            }
          ```
        - Response : 204 No Content

      - ##### Things persisted in the database
        
        - `pricing_groups` table
          | id | name                     | created_at                  | updated_at                  |
          |----|--------------------------|-----------------------------|-----------------------------|
          | 3  | Red Rim Color Special Price | 2024-08-04 16:57:03.457318  | 2024-08-04 16:57:03.457318  |

        - `pricing_groups_customizable_options` table
          | pricing_group_id | customizable_option_id |
          |------------------|-------------------------|
          | 3                | 2                       |
          | 3                | 5                       |

        - `customizable_option_price_by_groups` table
          | id | customizable_option_id | pricing_group_id | price | created_at                  | updated_at                  |
          |----|-------------------------|------------------|-------|-----------------------------|-----------------------------|
          | 3  | 10                      | 3                | 60.00 | 2024-08-04 16:57:03.489330  | 2024-08-04 16:57:03.489330  |



      - ##### Lets test this new pricing rule
        `Lets add a Bicycle to cart with Diamond Frame, Shiny Finish, Red Rim Color. Lets check the carts UI to find out what is Red Rim Color Pricing applied.`

        Notice how the price for `Red Rim Color` is `10 Euros` for the first two customized bicycle cart_items, **but for the third customized bicycle**, the price for `Red Rim Color` is `60 Euros` because the other two combinations are `Diamond Frame Type` and `Shiny Frame Finish`, which means our new pricing rule was applied.
        
        ![image](https://github.com/user-attachments/assets/0c271b5e-afb6-43ae-81d1-ed117b2330fd)


## Ruby on Rails - Key Classes
### Models
  - Cart
  - CartItem
  - Customer
  - Product
  - Customizable
  - CustomizableOption
  - PricingGroup
  - CustomizableOptionPriceByGroup

### Controllers
  - carts_controller

    Responsible for mantaining apis for cart related action (add item, view cart, etc)
  - products_controller

    Responsible for managing apis for product related actions (get all products, get specific product customizable info, add new product)
  - customizable_options_controller

    Responsible for managing apis for customizable_options related actions (get all customizable_options, add create option, update an option [price])
  - pricing_groups_controller

    Responsible for managing apis for special pricing related actions (create special pricing for an option based on option combinations)
    
## Observations, Assumptions, Points for future iterations
  To keep things light-weight and simple for now, following points are kept to be picked in future iterations - 
  - Authentication and authorization needs to be added. We can add jwt token authentication for all the APIs. Server will decode the token and get the user info accessing the website. User Authorization layer can also be added to sepcify access-levels.
  - Params Validation needs to be added. We will definitely add params validation for all API requests to enhance security of the application.
  - RSpec is used for adding test cases related to APIs. Basic controller specs are added. More robust model spec can be added. Going forward we should continue adding more specs to keep the API test suite robust.
  - RSpec performance consideration : Currently due to limited and light weight application, we have used seeds.rb file for test data setup. Loading seeds for each spec file run may slow down our tests. Going forward For larger test suites, we can consider using specific data factories or fixtures or created_stubbed for more efficient tests.
  - Audit trails needs to be maintained. In future iterations, we will definitely maintain audit_trails to keep the track of user/admin actions , especially with admin write operations.
  - Robust error handling will be added in APIs, so user is notified with appropriate error message for different kinds of backend errors (4xx, 5xx, etc).

## Testing
 - RSpec


   Tests are written in /spec/controllers directory. Total 9 tests covers scenarios like get all products, view specific product, add new product, view all customizable_options, add new customizable option, modify customizable_option, create special pricing combinations, view cart etc. The seed datais used to mock the test data.

   To run the specs -
    - Login to application's docker container
    - Run `rspec`
