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



### Optimisations
to-do

### Configurations
to-do

### Observations, Assumptions and Points
to-do

### Suggestions and Future Iterations
to-do audit_trails

### Testing
