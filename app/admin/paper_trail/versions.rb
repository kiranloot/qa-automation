ActiveAdmin.register PaperTrail::Version do
  menu false
  actions :all, except: [:destroy, :new, :update, :edit]

  show title: "Versions Comparison" do
    # This is the object before it is changed.
    original_object = paper_trail_version.reify
    changed_object  = original_object.next_version if original_object

    panel "" do
      if original_object.nil?
        text_node "This is the only version.".html_safe
      else
        columns do
          column do
            span "Version Before Change"

            attributes_table_for original_object do
              original_object.attributes.keys.each do |attribute|
                row attribute.to_sym
              end
            end
          end

          column do
            span "Version After Change"

            attributes_table_for changed_object do
              changed_object.attributes.keys.each do |attribute|
                row attribute.to_sym
              end
            end
          end
        end
      end
    end
  end
end