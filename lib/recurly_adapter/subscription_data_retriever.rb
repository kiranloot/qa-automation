module RecurlyAdapter
  class SubscriptionDataRetriever
    def initialize(uuid)
      @uuid = uuid
    end

    def invoices
      @invoices ||= account.invoices
    end

    def transactions
      @transactions ||= account.transactions
    end

    def subscription
      @subscription ||= Recurly::Subscription.find @uuid
    end

    def account
      @account ||= subscription.account
    end
  end
end