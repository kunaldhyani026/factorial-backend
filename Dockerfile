FROM ruby:3.1.0

# Create working directory in the container
RUN mkdir /factorial-backend

# Set the working directory in the container
WORKDIR /factorial-backend

# Get update
RUN apt-get update

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install dependencies using bundler
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose port 4000 to the outside world
EXPOSE 4000

# Command to start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "4000"]

# APIs accessible at: http://localhost:4000/