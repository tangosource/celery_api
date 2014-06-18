module Celery

  class User < Base

    attr_accessor :created, :updated, :created_date, :updated_date,
      :_id, :id, :email, :name, :currency, :webhooks, :notifications,
      :shipping_rates, :tax_rates, :nexus, :stripe, :affirm, :paypal_email,
      :analytics, :flags, :confirmation_url, :twitter, :facebook, :website,
      :subscription, :business, :has_affirm, :message_to_buyer, :access_token,
      :emails, :has_paypalx

    def update(attrs={})
      update_local_object(attrs)
      response = perform_request(attrs)
      return true if response['meta']['code'] == 200
    end

    def perform_request(attrs)
      HTTParty.put(
        Celery.endpoint + "users/me?" + Celery.parameterize_options,
        body: attrs.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def update_local_object(attrs)
      attrs.each { |key, value| self.send("#{key}=", value) }
    end

    class << self
      def me
        query_string  = Celery.endpoint + "users/me?"
        query_string += Celery.parameterize_options
        response = HTTParty.get(query_string)

        self.new(response['data'])
      end
    end
  end

end
