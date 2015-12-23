module ::Refinery
  module Admin
    module SettingsHelper
      def form_value_type
        @setting.form_value_type.presence || 'text_area'
      end

      def setting_title(f)
        if @setting.form_value_type == 'check_box'
          raw "<h3>#{@setting.name.to_s.titleize}?</h3>"
        else
          locale_scope = "refinery.admin.settings.form.#{@setting.name}.settings_value_name"
          f.label :value, t(locale_scope), :'data-locale-scope' => locale_scope
        end
      end

      def setting_field(f, help)
        case form_value_type
        when 'check_box'
          raw "#{f.check_box :value, :value => @setting.form_value}
               #{f.label :value, help.presence || t('enabled', :scope => 'refinery.admin.settings.form'),
                         :class => 'stripped'}"
        when 'text_area'
          f.text_area :value, :value => @setting.form_value,
                      :class => 'form-control', :rows => 5
        else
          f.text_field :value, :value => @setting.value, :class => "form-control"
        end
      end
    end
  end
end
