module Domain
  module Player
    extend self

    def list(by_record_index: false, page: nil, per: nil)
      query = ::Player.all
      query = query.record_index_order if by_record_index
      query = query.page(page) if page
      query = query.per(per) if per
      query
    end

    def search(term:)
      return ::Player.where('username ILIKE ? OR name ILIKE ?', "%#{term}%", "%#{term}%") if Rails.env.production?
      ::Player.where('username LIKE ? OR name LIKE ?', "%#{term}%", "%#{term}%")
    end

    def single(username: nil, either_name: nil, id: nil, create_missing: false, assert: false)
      player = Player::Find.call(
        username: username, either_name: either_name, id: id
      )
      player ||= create(name: either_name) if create_missing
      return player if player.present?

      raise ActiveRecord::RecordNotFound if assert
    end

    def create(name:, username: nil, twitch: nil, youtube: nil)
      Player::Create.call(
        name: name, username: username, twitch: twitch, youtube: youtube
      )
    end

    def update(id:, **attributes)
      Domain::Player::Update.call(::Player.find_by!(username: id), attributes)
    end

    def merge(from:, into:)
      from = ::Player.find_by!(username: from)
      into = ::Player.find_by!(username: into)
      Domain::Player::Merge.call(from: from, into: into)
    end

    def refresh_record_index(player: nil, players: nil)
      players = [player] if player.present?
      players = list if players == :all
      raise ArgumentError, 'No player provided' if players.blank?
      Player::RefreshRecordIndex.call(players)
    end
  end
end
