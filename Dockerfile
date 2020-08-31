FROM node:8-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . /app
RUN npm run build
#Create a new container from a linux base image that has the aws-cli installed
FROM mesosphere/aws-cli

#Using the alias defined for the first container, copy the contents of the build folder to this container
COPY --from=builder /app/build .

#Set the default command of this container to push the files from the working directory of this container to our s3 bucket 
CMD ["s3", "sync", "./", "s3://my-s3-bucket-genki"]