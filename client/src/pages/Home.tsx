import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useLocation } from 'wouter';
import { Button } from '@/components/ui/button';
import CategoryTabs from '../components/CategoryTabs';
import RestaurantCard from '../components/RestaurantCard';
import type { Restaurant } from '@shared/schema';

export default function Home() {
  const [, setLocation] = useLocation();
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

  const { data: restaurants, isLoading } = useQuery<Restaurant[]>({
    queryKey: ['/api/restaurants', ...(selectedCategory ? [`?categoryId=${selectedCategory}`] : [])],
  });

  const handleRestaurantClick = (restaurantId: string) => {
    setLocation(`/restaurant/${restaurantId}`);
  };

  return (
    <div>
      {/* Promo Banner */}
      <section className="p-4">
        <div className="hero-banner rounded-xl p-6 text-primary-foreground mb-6">
          <h2 className="text-xl font-bold mb-2">عروض خاصة</h2>
          <p className="text-sm opacity-90 mb-4">توصيل مجاني على الطلبات أكثر من 50 ريال</p>
          <Button 
            className="bg-primary-foreground text-primary hover:bg-primary-foreground/90"
            data-testid="button-order-now"
          >
            اطلب الآن
          </Button>
        </div>
      </section>

      {/* Category Tabs */}
      <CategoryTabs 
        selectedCategory={selectedCategory}
        onCategoryChange={setSelectedCategory}
      />

      {/* Restaurant List */}
      <section className="px-4 space-y-4">
        <h3 className="text-lg font-bold text-foreground mb-4">المطاعم القريبة منك</h3>
        
        {isLoading ? (
          <div className="space-y-4">
            {[...Array(3)].map((_, i) => (
              <div key={i} className="bg-card rounded-xl border border-border overflow-hidden">
                <div className="w-full h-48 bg-muted animate-pulse" />
                <div className="p-4 space-y-3">
                  <div className="h-4 bg-muted rounded animate-pulse" />
                  <div className="h-3 bg-muted rounded w-3/4 animate-pulse" />
                  <div className="h-3 bg-muted rounded w-1/2 animate-pulse" />
                </div>
              </div>
            ))}
          </div>
        ) : restaurants?.length ? (
          restaurants.map((restaurant) => (
            <RestaurantCard
              key={restaurant.id}
              restaurant={restaurant}
              onClick={() => handleRestaurantClick(restaurant.id)}
            />
          ))
        ) : (
          <div className="text-center text-muted-foreground py-8">
            <p>لا توجد مطاعم متاحة في هذا التصنيف</p>
          </div>
        )}
      </section>
    </div>
  );
}
