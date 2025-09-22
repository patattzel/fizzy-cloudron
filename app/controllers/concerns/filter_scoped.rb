module FilterScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_filter
    before_action :set_user_filtering
  end

  class_methods do
    def enable_collection_filtering(**options)
      before_action :enable_collection_filtering, **options
    end
  end

  private
    def set_filter
      if params[:filter_id].present?
        @filter = Current.user.filters.find(params[:filter_id])
      else
        @filter = Current.user.filters.from_params filter_params
      end
    end

    def filter_params
      params.reverse_merge(**Filter.default_values).permit(*Filter::PERMITTED_PARAMS)
    end

    def set_user_filtering
      @user_filtering = User::Filtering.new(Current.user, @filter, expanded: expanded_param)
    end

    def expanded_param
      ActiveRecord::Type::Boolean.new.cast(params[:expand_all])
    end

    def enable_collection_filtering
      # We pass a block so that we don't have to pass around the script_name and host
      # to the model to make +url_for+ invocable
      @user_filtering.enable_collection_filtering do |**options|
        url_for(options)
      end
    end

    def enable_referral_collection_filtering
      @user_filtering.enable_collection_filtering do |**options|
        if request.referer.present?
          uri = URI.parse(request.referer)
          uri.query = Rack::Utils.build_query(options)
          uri.to_s
        else
          url_for(options)
        end
      end
    end
end
