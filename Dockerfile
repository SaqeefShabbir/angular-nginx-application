# 1. Build our Angular app
FROM node:latest as builder

# Set the working directory
WORKDIR /usr/local/app

# Add the source code to app
COPY ./ /usr/local/app/

# Clean install all the dependencies
RUN npm ci

# Install angular cli
RUN npm install --save-dev @angular/cli@latest

# Generate the build of the application
RUN npm run build --prod --output-path=/dist

# 2. Deploy our Angular app to NGINX
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=builder /usr/local/app/dist/angular-nginx-docker /usr/share/nginx/html

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]