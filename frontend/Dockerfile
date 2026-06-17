FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies from the lockfile (installs the platform-correct
# rollup binary, e.g. @rollup/rollup-linux-arm64-musl on Alpine)
RUN npm ci

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 5173

# Start the development server
CMD ["npm", "run", "dev", "--", "--host"]