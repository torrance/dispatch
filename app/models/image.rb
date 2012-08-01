class Image < ActiveRecord::Base
  attr_accessible :image, :weight
  belongs_to :content

  validates :image_file_name, :presence => true
  validates :image, :attachment_size => { 
    :in => 0..15.megabytes,
    :message => "^Images must be under 15Mb each."
  }
  validates :image, :attachment_content_type => { 
    :content_type => /image/ ,
    :message => "^You have attempted to upload something that isn't a valid image."
  }

  default_scope order('weight ASC')

  has_attached_file :image, :styles => {
    :article => ["695x470", :jpg],
    :gallery_thumbnail => ["140x140#", :jpg],
    :gallery_full => ["900x900", :jpg],
    :primary_feature => ["510x300#", :jpg],
    :feature_square => ["110x110#", :jpg],
    :sub_feature => ["235x150#", :jpg],
    :tiny => ["80x80#", :jpg]
  }
end
