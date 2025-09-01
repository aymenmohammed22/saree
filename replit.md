# Overview

This is a modern food delivery application called "السريع ون" (Fast One) built with React frontend and Express.js backend. The application allows users to browse restaurants by category, view menus, add items to cart, and place orders. It features a comprehensive admin panel for managing restaurants, categories, menu items, and orders.

# User Preferences

Preferred communication style: Simple, everyday language.

# System Architecture

## Frontend Architecture
- **Framework**: React 18 with TypeScript
- **Build Tool**: Vite for fast development and optimized builds
- **Styling**: Tailwind CSS with shadcn/ui component library
- **State Management**: React Context API for cart and theme management
- **Data Fetching**: TanStack Query (React Query) for server state management
- **Routing**: Wouter for lightweight client-side routing
- **UI Components**: Radix UI primitives with custom styled components

## Backend Architecture
- **Framework**: Express.js with TypeScript
- **Database ORM**: Drizzle ORM for type-safe database operations
- **Database**: PostgreSQL with Neon Database hosting
- **API Design**: RESTful endpoints with proper HTTP status codes
- **File Structure**: Modular route handlers with separate storage layer
- **Development**: Hot-reload with Vite integration for full-stack development

## Database Schema
The application uses PostgreSQL with the following main entities:
- **Users**: Basic authentication with username/password
- **Categories**: Restaurant categorization (مطاعم، مقاهي، حلويات، etc.)
- **Restaurants**: Restaurant information including ratings, delivery times, and status
- **Menu Items**: Products with pricing, categories, and special offers
- **Orders**: Order management with customer details and item lists
- **Drivers**: Delivery driver management system

## Key Design Patterns
- **Separation of Concerns**: Clear separation between frontend, backend, and database layers
- **Type Safety**: Full TypeScript implementation with shared types between frontend and backend
- **Component Composition**: Reusable UI components with consistent design system
- **State Management**: Context providers for global state (cart, theme) with local component state
- **Error Handling**: Centralized error handling with user-friendly toast notifications

## Mobile-First Design
- Responsive design optimized for mobile devices
- Touch-friendly interface with floating cart button
- Arabic language support with proper RTL considerations
- Native-like mobile app experience

# External Dependencies

## Database & Hosting
- **Neon Database**: PostgreSQL hosting service for production database
- **Drizzle Kit**: Database migration and schema management tools

## UI & Styling
- **shadcn/ui**: Pre-built accessible UI components
- **Radix UI**: Headless UI primitives for complex components
- **Tailwind CSS**: Utility-first CSS framework
- **Lucide React**: Icon library for consistent iconography

## Development Tools
- **Vite**: Fast build tool with HMR support
- **TypeScript**: Type safety across the entire application
- **ESBuild**: Fast JavaScript bundler for production builds

## External Services
- **Font Integration**: Google Fonts for Arabic (Noto Sans Arabic) and Latin (Inter) typography
- **Replit Integration**: Development environment optimizations and error reporting

## Form Handling & Validation
- **React Hook Form**: Efficient form state management
- **Zod**: Schema validation for both frontend and backend
- **Hookform Resolvers**: Integration between React Hook Form and Zod

The application is designed to be easily deployable on platforms like Replit while maintaining production-ready code quality and performance.