from pydantic_settings import BaseSettings, SettingsConfigDict
class Settings(BaseSettings):
    app_name: str = 'AI Infrastructure Sizing API'
    environment: str = 'development'
    model_config = SettingsConfigDict(env_file='.env', extra='ignore')
settings = Settings()
