### STAGE 1:BUILD ###
# Defining a node image to be used as giving it an alias of "build"
# Which version of Node image to use depends on project dependencies 
# This is needed to build and compile our code 
# while generating the docker image
FROM node:latest AS build
# Create a Virtual directory inside the docker image
WORKDIR /dist/src/app
# Copy files to virtual directory
COPY package.json .
# Run command in Virtual directory
RUN npm cache clean --force
RUN npm config list
RUN curl https://registry.npmjs.org/@angular%2fanimations
RUN npm install --verbose
# Copy files from local machine to virtual directory in docker image
COPY . .
RUN npm run build --prod


### STAGE 2:RUN ###
# Defining nginx image to be used
FROM nginx:latest AS ngi
# Copying compiled code and nginx config to different folder
# NOTE: This path may change according to your project's output folder 
COPY --from=build /dist/src/app/dist/myproject /usr/share/nginx/html
RUN pwd
COPY /nginx.conf  /etc/nginx/conf.d/default.conf
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
RUN sed -i.bak 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# Exposing a port, here it means that inside the container 
# the app will be using Port 8080 while running
EXPOSE 8080
