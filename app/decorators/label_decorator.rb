class LabelDecorator < ApplicationDecorator
  delegate_all

  BADGE_COLORS = {
    'no_color' => 'color:black; background-color: white',
    'gray' =>     'color:white; background-color: dimgray',
    'red' =>      'color:white; background-color: red',
    'yellow' =>   'color:black; background-color: gold',
    'green' =>    'color:white; background-color: lime',
    'blue' =>     'color:white; background-color: blue'
  }.freeze

  def badge
    h.link_to(object.name,
              h.tasks_path(label_id: object.id),
              class: 'badge badge-pill',
              style: BADGE_COLORS[object.color])
  end

  def self.color_options_for_select
    colors =
      Label.colors.keys.map do |c|
        [I18n.t("activerecord.attributes.label.#{c}"), c]
      end

    h.options_for_select(colors)
  end
end
