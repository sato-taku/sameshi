module ApplicationHelper
  def default_meta_tags
    {
      site: 'サ飯の時間',
      title: '',
      reverse: true,
      charset: 'utf-8',
      description: '「サウナ飯」、通称「サ飯」愛好家のための新しいコミュニティです。サウナとお気に入りの「サ飯」を投稿することで新しいサウナとサ飯のモデルルートに出逢えるかも',
      keywords: 'サウナ,サウナ飯,サ飯',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      # Twitter用の設定を個別で設定
      twitter: {
        card: 'summary_large_image',
        site: '@sttk_91',
        image: image_url('ogp.png')
      }
    }
  end

  def page_title(page_title = '')
    base_title = 'サ飯の時間'

    page_title.empty? ? base_title : page_title + ' | ' + base_title
  end

  def flash_background_color(type)
    case type.to_sym
    when :success then "bg-success"
    when :danger  then "bg-error"
    else "bg-info"
    end
  end
end
