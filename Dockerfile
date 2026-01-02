# Stage 1: Build the React application
FROM node:20-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
# to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application
# 'build' script is typically defined in package.json
RUN npm run build

# --- Stage 2: Production Stage ---
# Use a lean, production-ready Node.js image
FROM node:20-alpine AS production

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
# This includes node_modules and your application code
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app ./

# If your app needs a specific user (recommended for security)
# The official Node.js images provide a 'node' user (UID 1000)
USER node

# Expose the port your Node.js application listens on
EXPOSE 3000

# Command to run your Node.js application
# Use 'node' directly instead of 'npm start' if possible to avoid an extra shell process
#CMD ["node", "server.js"]
# Or if your package.json has a 'start' script and you prefer it:
 CMD ["npm", "start"]