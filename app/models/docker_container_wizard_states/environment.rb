module DockerContainerWizardStates
  class Environment < ActiveRecord::Base
    self.table_name_prefix = 'docker_container_wizard_states_'
    belongs_to :wizard_state, :class_name => DockerContainerWizardState

    attr_accessible :tty, :docker_container_wizard_state_id,
                    :attach_stdin, :attach_stdout, :attach_stderr,
                    :exposed_ports_attributes, :environment_variables_attributes,
                    :dns_attributes
    # Fix me:
    # Validations are off on this association as there's a bug in ::Parameter
    # that forces validation of reference_id. This will fail on new records as
    # validations are executed before parent and children records have been persisted.
    has_many :environment_variables, :dependent  => :destroy, :foreign_key => :reference_id,
                                     :inverse_of => :environment,
                                     :class_name =>
                                       'DockerContainerWizardStates::EnvironmentVariable',
                                     :validate => false
    include ::ParameterValidators

    has_many :exposed_ports,  :dependent  => :destroy, :foreign_key => :reference_id,
                              :inverse_of => :environment,
                              :class_name => 'DockerContainerWizardStates::ExposedPort',
                              :validate => true
    has_many :dns,  :dependent  => :destroy, :foreign_key => :reference_id,
                    :inverse_of => :environment,
                    :class_name => 'DockerContainerWizardStates::Dns',
                    :validate => true

    accepts_nested_attributes_for :environment_variables, :allow_destroy => true
    accepts_nested_attributes_for :exposed_ports, :allow_destroy => true
    accepts_nested_attributes_for :dns, :allow_destroy => true

    def parameters_symbol
      :environment_variables
    end
  end
end
