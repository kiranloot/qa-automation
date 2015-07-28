module RecurlyAdapter
  class AccountService
    def initialize(recurly_account_id)
      @recurly_account_id = recurly_account_id
    end

    def update(options)
      account.update_attributes! options
    end

    def account
      unless defined?(@account)
        @account = Recurly::Account.find(@recurly_account_id)
      end
      @account
    end
  end
end
