class MoveDockerImagesToDockerRepositories < ActiveRecord::Migration
  def change
    rename_index :docker_tags, :docker_tags_docker_image_id_fk, :docker_tags_docker_repository_id_fk
    rename_index :containers, :containers_docker_image_id_fk, :containers_docker_repository_id_fk

    rename_table :docker_images, :docker_repositories

    rename_column :docker_repositories, :image_id, :name
    rename_column :containers,  :docker_image_id, :docker_repository_id
    rename_column :docker_tags, :docker_image_id, :docker_repository_id
  end
end
