import { Switch, Route } from "wouter";
import { queryClient } from "./lib/queryClient";
import { QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { CartProvider } from "./context/CartContext";
import { ThemeProvider } from "./context/ThemeContext";
import { AuthProvider, useAuth } from "./context/AuthContext";
import Layout from "./components/Layout";
import { LoginPage } from "./pages/LoginPage";
import { AdminDashboard } from "./pages/AdminDashboard";
import { DriverDashboard } from "./pages/DriverDashboard";
import { useState } from "react";
import Home from "./pages/Home";
import Restaurant from "./pages/Restaurant";
import Cart from "./pages/Cart";
import Profile from "./pages/Profile";
import Location from "./pages/Location";
import OrderTracking from "./pages/OrderTracking";
import Settings from "./pages/Settings";
import Privacy from "./pages/Privacy";
import Admin from "./pages/Admin";
import AdminCategories from "./pages/AdminCategories";
import AdminOrders from "./pages/AdminOrders";
import AdminDrivers from "./pages/AdminDrivers";
import AdminRestaurants from "./pages/AdminRestaurants";
import Delivery from "./pages/Delivery";
import NotFound from "@/pages/not-found";

function AuthenticatedApp() {
  const { isAuthenticated, userType, loading } = useAuth();
  const [showLogin, setShowLogin] = useState(false);

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-primary mx-auto"></div>
          <p className="mt-4 text-gray-600">جاري التحميل...</p>
        </div>
      </div>
    );
  }

  // Handle login routes
  if (window.location.pathname === '/admin-login' || showLogin) {
    return (
      <LoginPage 
        onSuccess={() => {
          setShowLogin(false);
          window.location.href = '/';
        }} 
      />
    );
  }

  // If authenticated, show appropriate dashboard
  if (isAuthenticated) {
    if (userType === 'admin') {
      return (
        <AdminDashboard 
          onLogout={() => {
            window.location.href = '/';
          }} 
        />
      );
    } else if (userType === 'driver') {
      return (
        <DriverDashboard 
          onLogout={() => {
            window.location.href = '/';
          }} 
        />
      );
    }
  }

  // Default customer app
  return (
    <Layout>
      <Router />
    </Layout>
  );
}

function Router() {
  return (
    <Switch>
      <Route path="/" component={Home} />
      <Route path="/restaurant/:id" component={Restaurant} />
      <Route path="/cart" component={Cart} />
      <Route path="/profile" component={Profile} />
      <Route path="/addresses" component={Location} />
      <Route path="/orders/:orderId" component={OrderTracking} />
      <Route path="/orders" component={() => <OrderTracking />} />
      <Route path="/settings" component={Settings} />
      <Route path="/privacy" component={Privacy} />
      <Route path="/admin" component={Admin} />
      <Route path="/admin/categories" component={AdminCategories} />
      <Route path="/admin/orders" component={AdminOrders} />
      <Route path="/admin/drivers" component={AdminDrivers} />
      <Route path="/admin/restaurants" component={AdminRestaurants} />
      <Route path="/delivery" component={Delivery} />
      <Route component={NotFound} />
    </Switch>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <ThemeProvider>
          <AuthProvider>
            <CartProvider>
              <Toaster />
              <AuthenticatedApp />
            </CartProvider>
          </AuthProvider>
        </ThemeProvider>
      </TooltipProvider>
    </QueryClientProvider>
  );
}

export default App;
