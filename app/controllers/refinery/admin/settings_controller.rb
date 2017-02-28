module ::Refinery
  module Admin
    class SettingsController < ::Refinery::AdminController

      helper "refinery/admin/settings"

      crudify :'refinery/setting',
              :order => "name ASC",
              :redirect_to_url => :redirect_to_where?

      def new
        form_value_type = ((current_refinery_user.has_role?(:superuser) && params[:form_value_type]) || 'text_area')
        @setting = ::Refinery::Setting.new(:form_value_type => form_value_type)
      end

      def edit
        @setting = ::Refinery::Setting.find(params[:id])

        render :layout => false if request.xhr?
      end

      def multi_update
        result = true
        params['settings'].each do |i, setting_hash|
          setting = find_setting_scope.find(setting_hash[:name])
          if !setting.update_attributes(setting_hash.permit(:name, :value))
            result = false
          end
        end

        result ? create_or_update_successful : create_or_update_unsuccessful('edit')
      end

    protected
      def find_all_settings
        @settings = ::Refinery::Setting.order('name ASC')

        unless current_refinery_user.has_role?(:superuser)
          @settings = @settings.where("restricted <> ? ", true)
        end

        @settings
      end

      def search_all_settings
        # search for settings that begin with keyword
        term = "^" + params[:search].to_s.downcase.gsub(' ', '_')

        # First find normal results, then weight them with the query.
         @settings = find_all_settings.with_query(term)
      end

    private
      def redirect_to_where?
        (from_dialog? && session[:return_to].present?) ? session[:return_to] : refinery.admin_settings_path
      end

      def setting_params
        params.require(:setting).permit(:title, :name, :value, :destroyable, :restricted, :form_value_type)
      end

    end
  end
end
