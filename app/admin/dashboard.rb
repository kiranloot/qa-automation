ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1

  page_action :export_csv do
    Admin::CsvUploaderWorker.perform_async

    flash[:notice] = "Generating new orders csv. Refresh this page in a few minutes and a download link will appear."
    redirect_to admin_dashboard_path
  end

  action_item(:order_csv) do
    if OrdersCsv.all.present?
      csv = OrdersCsv.all.last
      ago = distance_of_time_in_words(Time.now - csv.created_at)
      link_to "Download orders CSV (from #{ago} ago)", csv.url
    end
  end

  action_item(:generate_new_csv) do
    link_to "Generate new orders CSV", admin_dashboard_export_csv_path, class: 'new_orders_csv'
  end

  content :title => "Dashboard" do
    columns do
      subscription_status_aggregates = Subscription::Reporting::Aggregates.subscription_status
      @past_due = subscription_status_aggregates['past_due'].to_i
      @total    = subscription_status_aggregates['active'].to_i

      column do
        panel "Quick Aggregates" do
          h2 "Shirt Sizes"

          Subscription::Reporting::Aggregates.active_by_shirt_size.each do |size, count|
            title = ShirtSize.readable(size)

            h4 :style => "margin:1.25em 0 0 0" do
              span "#{title} ("
              span count, :style => "color:orangered"
              span ")"
            end

            progress :value => count, :max => @total, :style => "width:100%"
          end
        end
      end

      column do
        panel "Subscription Info" do
          h2 "Subscriptions (#{@total + @past_due})"
          h4 "active - #{@total}"
          h4 "past_due - #{@past_due}"

          Subscription::Reporting::Aggregates.active_by_plan.each do |plan, count|
            next if plan.name == "ca-3-month-subscription"
            next if plan.name == "ca-6-month-subscription"

            title = plan.readable_name

            h4 :style => "margin:1.25em 0 0 0" do
              span "#{title} ("
              span count, :style => "color:orangered"
              span ")"
            end
            progress :value => count, :max => @total, :style => "width:100%"
          end
        end
      end
    end
  end

end
