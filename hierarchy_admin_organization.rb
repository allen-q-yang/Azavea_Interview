# frozen_string_literal: true

# Model for Hierarchy Admin Organization
class HierarchyAdminOrganization
  include ActiveModel::Model

  # Filter those expandable Admin Organizations which are in Hierarchy Organizations Map.
  # Then, get their member organizations in the map. If Admin Organization is nil, return all
  # organizations in Hierarchy Organizations Map.
  #
  # hierarchy_organizations_map - all the dynamic organizatons and their member organizations we have in our table.
  # admin_organizations - the admin organizations we need to filter.
  #
  # Return - a plain array that contain all the organizations
  def self.where(hierarchy_organizations_map:, admin_organizations:)
    hierarchy_admin_orgs = hierarchy_organizations_map.keys

    if admin_organizations.nil? == false
      admin_organizations.map! { |admin_org| admin_org.to_h.slice(:id) }
      hierarchy_admin_orgs &= admin_organizations
      hierarchy_admin_orgs |= hierarchy_organizations_map.map { |org, members| members if org.in? admin_organizations }
      hierarchy_admin_orgs.flatten!
      hierarchy_admin_orgs.uniq!
      hierarchy_admin_orgs.compact!
    end
    hierarchy_admin_orgs
  end
end
