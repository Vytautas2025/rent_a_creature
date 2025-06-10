# Rent a Creature

Rent a Creature is a web application inspired by Pokémon, allowing users to list, discover, and book unique fantasy creatures. Owners can showcase their creatures, manage bookings, and update availability, while renters can browse, view details, and book available creatures.

## Features

- **Creature Management:** Create, edit, display, and delete creatures with details like name, description, price, availability, owner, and images.
- **Booking Workflow:** Book creatures, manage your bookings, and cancel if needed. Owners can accept or reject bookings for their creatures.
- **User Roles & Access Control:** Owners and renters have different permissions and UI options (edit, delete, book, manage bookings).
- **Interactive Maps:** Integrated Mapbox for displaying creature locations on the detail page.
- **Responsive UI:** Custom, Pokémon-inspired design for cards, detail pages, and action buttons.

## Getting Started

### Prerequisites
- Ruby on Rails
- PostgreSQL
- Node.js & Yarn
- Cloudinary account (for image uploads)
- Mapbox API key (for maps)

### Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/rent_a_creature.git
   cd rent_a_creature
   ```
2. Install dependencies:
   ```sh
   bundle install
   yarn install
   ```
3. Set up the database:
   ```sh
   rails db:create db:migrate db:seed
   ```
4. Configure environment variables:
   - `CLOUDINARY_URL` for image uploads
   - `MAPBOX_API_KEY` for maps
   - (Optional) other secrets in `config/credentials.yml.enc`
5. Start the server:
   ```sh
   rails server
   ```
6. Visit [https://create-a-creature-7e784828c7e4.herokuapp.com/](https://create-a-creature-7e784828c7e4.herokuapp.com/) in your browser.

## Usage
- Browse featured creatures on the home page.
- Click a creature card to view details, location, and owner info.
- Book available creatures or manage your own listings and bookings.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
