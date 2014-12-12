class DockerRegistry < ActiveRecord::Base
  include Authorizable
  include Taxonomix

  has_many :repositories, :class_name => 'DockerRepository', :foreign_key => 'docker_registry_id',
    :dependent => :destroy

  scoped_search :on => :name, :complete_value => true
  scoped_search :on => :url

  def used_location_ids
    Location.joins(:taxable_taxonomies).where(
        'taxable_taxonomies.taxable_type' => 'DockerRegistry',
        'taxable_taxonomies.taxable_id' => id).pluck(:id)
  end

  def used_organization_ids
    Organization.joins(:taxable_taxonomies).where(
        'taxable_taxonomies.taxable_type' => 'DockerRegistry',
        'taxable_taxonomies.taxable_id' => id).pluck(:id)
  end
end
