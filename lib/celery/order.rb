module Celery

  class Order < Base
    attr_accessor :id, :status, :name, :image, :slug,
      :auto_charge, :seller, :buyer, :payment, :products,
      :coupon, :subtotal, :total, :deposit, :balance, :discount,
      :shipping, :taxes, :currency, :celery_payment_token, :card,
      :tracking, :fulfillment, :notes, :confirmation_url, :updated,
      :updated_date, :created, :created_date, :_id, :metadata, :flags

    def products=(products)
      @products = []
      products.each do |product|
        @products << Celery::Product.new(product)
      end
    end

    def buyer=(buyer)
      @buyer = Celery::Buyer.new(buyer)
    end

    def seller=(seller)
      @seller = Celery::Seller.new(seller)
    end

    def tracking=(tracking)
      @tracking = Celery::Tracking.new(tracking)
    end

    def card=(card)
      @card = Celery::Card.new(card)
    end

    class << self
      def all(args={})
        endpoint_path = Celery.endpoint + "orders"
        options       = Celery.parameterize_options(args)
        response = HTTParty.get("#{endpoint_path}?#{options}")
        return build_orders(response['orders'])
      end

      def build_orders(orders)
        orders.map do |order|
          Celery::Order.new(order)
        end
      end

      def decode(encoded_string)
        decoded_string = Base64.decode64(encoded_string)
        Celery::Order.new(JSON.parse(decoded_string))
      end
    end
  end

end
