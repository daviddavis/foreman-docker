class MoveDockerImagesToDockerRepositories < ActiveRecord::Migration
  def up
    remove_foreign_key :docker_tags, :name => :docker_tags_docker_image_id_fk
    remove_foreign_key :containers, :name => :containers_docker_image_id_fk
    drop_table :docker_images

    create_table :docker_repositories do |t|
      t.string  :name
      t.references :docker_registry
      t.timestamps
    end

    remove_column :containers, :docker_image_id
    remove_column :docker_tags, :docker_image_id
    add_column :containers, :docker_repository_id, :integer
    add_column :docker_tags, :docker_repository_id, :integer

    add_foreign_key :containers, :docker_repositories,
                    :column => :docker_repository_id
    add_foreign_key :docker_tags, :docker_repositories,
                    :column => :docker_repository_id
    add_foreign_key :docker_repositories, :docker_registries,
                    :column => :docker_registry_id
  end

  def down
    create_table :docker_images do |t|
      t.string  :image_id
      t.integer :size
      t.timestamps
    end
    drop_table :docker_repositories

    add_foreign_key :docker_tags, :docker_images,
                    :column => :docker_image_id
    add_foreign_key :containers, :docker_images,
                    :column => :docker_image_id

    add_column :containers, :docker_image_id, :integer
    add_column :docker_tags, :docker_image_id, :integer
    remove_column :containers, :docker_repository_id
    remove_column :docker_tags, :docker_repository_id
  end
end
