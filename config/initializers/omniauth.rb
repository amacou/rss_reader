Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, 'D4hBCeVfkYFkLgCNmvgP1A', 'qR1HbgISwLd7rz4vYrWHWD2ngT7WeM62iBjUH2itBk'
  provider :facebook, '594058497285513', 'a545d4bc4312aad54eef98cef06dd905'
end
