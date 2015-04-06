module Api
  module V2
    class DockerRegistriesController < ::Api::V2::BaseController
      before_filter :find_resource, :except => %w(index create)

      resource_description do
        resource_id 'docker_registries'
        api_version 'v2'
        api_base_url '/docker/api/v2'
      end

      def_param_group :registry do
        param :docker_registry, Hash, :required => true, :action_aware => true do
          param :name, String, :required => true
          param :url, String, :required => true
          param :description, String
          param :username, String
          param :password, String
        end
      end

      api :GET, '/docker_registries/', N_('List all docker registries')
      param_group :search_and_pagination, ::Api::V2::BaseController
      def index
        @registries = DockerRegistry.search_for(params[:search], :order => params[:order])
                      .paginate(:page => params[:page])
      end

      api :GET, '/docker_registries/:id', N_("Show a docker registry")
      param :id, :identifier, :required => true
      def show
        @registry = @docker_registry
      end

      api :POST, '/docker_registries/', N_('Create a docker registry')
      param_group :registry, :as => :create
      def create
        @registry = DockerRegistry.new(params[:docker_registry])
        process_response @registry.save
      end

      api :PUT, '/docker_registries/:id', N_('Update a docker registry')
      param :id, :identifier, :required => true
      param_group :registry, :as => :update
      def update
        @registry = @docker_registry
        if @registry.update_attributes(params[:docker_registry])
          process_success
        else
          process_error
        end
      end

      api :DELETE, '/docker_registries/:id/', N_('Delete a docker registry')
      param :id, :identifier, :required => true
      def destroy
        process_response @docker_registry.destroy
      end

      # rubocop:disable Style/TrivialAccessors, Style/AccessorMethodName
      def get_resource
        @registry
      end

      def docker_registry_url(registry)
        registry.url
      end
    end
  end
end