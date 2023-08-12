# Event Manager

## Outline

This project is a event manager for individuals, coworkers... to help organize the user's schedule, improve their workload management and support their daily activities.

As of now, it is only meant to be used both in PC.

## Getting Started

The only prerequisite to run the project is to install docker on your machine. There are different options:

- [Docker Desktop](https://docs.docker.com/get-docker/)
- [Lima](https://github.com/lima-vm/lima/blob/master/examples/docker.yaml)

### Application Architecture

This project follows a monolithic architecture, where all components of the application are bundled together into a single codebase.

It is containerized using **Docker** and orchestrated using **Docker Compose**. The architecture consists of four services:

- `web`: encapsulates the Ruby on Rails application.
- `db`: manages the application's database using PostgreSQL.
- `redis`: in-memory caching and background job processing.
- `sidekiq`: background job queue using the Sidekiq framework.

### Frameworks & Toolkit information

The core of the application relies on **Ruby on Rails**, a powerful and versatile web framework. The application data is stored in a **PostgreSQL** database container, ensuring data durability and consistency. In the frontend we use **Slim**, to write more concise and readable HTML code.

We use **Docker** as the containerization tool, in order to easily manage the project environment. For testing, we use **RSpec**, a robust testing framework, to ensure the stability and reliability of the application. During development, we have also used **Letter Opener** since it allows you to preview emails in the browser, minimizing the need for actual email sends.

Finally, for maintaining an organized and readable codebase, we follow the community Ruby style guide using **RuboCop** and we rely on **Brakeman** for security analysis.

## Get the project running

Navigate to the project directory and execute:

```
docker compose build
```

This will create images for the services defined in the `docker-compose.yml` file, including the database, web server, and any additional services.

- Create, migrate and seed the database.

```
docker compose run --rm web rake db:create db:migrate db:seed
```

This will create a `development` database and seed it with a premade instance of the server we will be using.

**IMPORTANT**
When running the `seeds` command, you'll be able to view a list of created users and the events to which they've been invited. This provides a convenient way to explore the core functionality of the project for testing purposes.

- Run the container.

```
docker compose up
```

When finished, we will shut it down correctly and remove the running containers.

```
docker compose down
```

## Using the app locally

After running the app, open [http://localhost:3000](http://localhost:3000) to view it in the browser.

## Testing

There are several tests (unit tests, integration tests, end-to-end tests) put in place to make sure the application is running the way we expect to.

To run the tests we run the following command:

```
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec
```

## Future Enhancements

While I've successfully added some tweaks to the logic in the project, there are areas that I've yet to cover due to project priorities and time constraints. Here's a breakdown of what we can consider for future enhancements:

- Role-Based Authorization: Enhance security and control by implementing role-based authorization using the [Pundit](https://github.com/varvet/pundit) gem, ensuring that users have appropriate access levels to different sections of the application.
- Two-Factor Authentication (2FA): Strengthen user account security by incorporating Two-Factor Authentication, adding an extra layer of protection against unauthorized access.
- Improved User Experience: Introduce AJAX requests for accepting or rejecting event invitations, creating a smoother and more responsive user experience.
- Frontend Enhancement: Enhance the frontend design and layout to create a more visually appealing and user-friendly interface.

## Conclusion and Acknowledgments

Thank you for checking out our project! We hope this README has provided you with a comprehensive understanding of what our application does and how to use it effectively. If you encounter any issues or have questions, please don't hesitate to reach out to us.

## Getting Help and Support

If you need help or have questions about using this project, you can [create an issue](https://github.com/josem-gp/event-manager/issues) on GitHub.

Thank you for using our project!
