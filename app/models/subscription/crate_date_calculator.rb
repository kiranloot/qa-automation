class Subscription
  class CrateDateCalculator
    class << self

      def current_crate_month_year
        to_month_year(current_crate_date)
      end

      def next_crate_month_year
        to_month_year(current_crate_date.next_month)
      end

      def current_crate_date
        # Find which crate should ship 'this month'.
        # I'm using the last possible moment of a "shipping month" for consistency
        # with other date-related calculations in this model
        now = DateTime.now
        end_of_day_on_the_nineteenth = DateTime.new(now.year,now.month,19).end_of_day.change(:offset => '-0500')

        if now < end_of_day_on_the_nineteenth
          d = end_of_day_on_the_nineteenth
        else
          d = end_of_day_on_the_nineteenth + 1.month
        end

        d
      end

      def current_crate_month
        now = DateTime.now
        nineteenth = DateTime.new(now.year,now.month,19).end_of_day.change(:offset => '-0500')

        crate_month = nil

        if now < nineteenth
          crate_month = now.strftime('%B')
        else
          crate_month = (now + 1.month).strftime('%B')
        end

        crate_month
      end

      def next_crate_month
        now = DateTime.now
        nineteenth = DateTime.new(now.year,now.month,19).end_of_day.change(:offset => '-0500')

        crate_month = nil

        if now < nineteenth
          crate_month = (now + 1.month).strftime('%B')
        else
          crate_month = (now + 2.month).strftime('%B')
        end

        crate_month
      end

      def last_20th
        now = DateTime.now.change(:offset => '-0500')

        if now.day >= 20
          d = DateTime.new(now.year,now.month,20).beginning_of_day
        else
          last_month = now - 1.month
          d = DateTime.new(last_month.year,last_month.month,20).beginning_of_day
        end
        d
      end

      private
        def to_month_year(date)
          date.strftime("%b%Y").upcase
        end

    end
  end
end
