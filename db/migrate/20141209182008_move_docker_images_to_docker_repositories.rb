class MoveDockerImagesToDockerRepositories < ActiveRecord::Migration
  def change
    remove_foreign_key :docker_tags, :name => :docker_tags_docker_image_id_fk
    remove_foreign_key :containers, :name => :containers_docker_image_id_fk

    rename_table :docker_images, :docker_repositories

    rename_column :docker_repositories, :image_id, :name
    rename_column :containers,  :docker_image_id, :docker_repository_id
    rename_column :docker_tags, :docker_image_id, :docker_repository_id

    add_foreign_key :docker_tags, :docker_repositories
    add_foreign_key :containers, :docekr_repositories
  end
end
