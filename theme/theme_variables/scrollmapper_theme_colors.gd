extends Resource
class_name ScrollmapperThemeColors

## Central semantic color palette for Scrollmapper's interface.
## Use the bright, base, and dark members as a controlled three-step scale:
## bright for hover/focus, base for normal emphasis, and dark for pressed/subdued states.


@export_group("Theme — Primary Blue")

## Primarily used for high-energy focus rings, active graph nodes, hovered analytical controls, and selected links.
@export var primary_blue_bright: Color = Color("#55C7F5")
## Primarily used for active controls, hyperlinks, graph relationships, selections, and analytical emphasis.
@export var primary_blue: Color = Color("#168CC5")
## Primarily used for pressed controls, subdued blue panels, deep graph edges, and blue-toned selection backgrounds.
@export var primary_blue_dark: Color = Color("#07527E")

func get_primary_blue_bright() -> Color:
	return primary_blue_bright

func get_primary_blue() -> Color:
	return primary_blue

func get_primary_blue_dark() -> Color:
	return primary_blue_dark


@export_group("Theme — Secondary Gold")

## Primarily used for luminous historical highlights, major discoveries, premium emphasis, and hovered gold controls.
@export var secondary_gold_bright: Color = Color("#F4CF78")
## Primarily used for source-text emphasis, significant selections, scholarly accents, and important dividers.
@export var secondary_gold: Color = Color("#C7923D")
## Primarily used for pressed gold controls, subdued historical markers, warm borders, and gold-toned panel layers.
@export var secondary_gold_dark: Color = Color("#76501F")

func get_secondary_gold_bright() -> Color:
	return secondary_gold_bright

func get_secondary_gold() -> Color:
	return secondary_gold

func get_secondary_gold_dark() -> Color:
	return secondary_gold_dark


@export_group("Theme — Background Navy")

## Primarily used for raised workspace regions, hoverable background layers, and the lightest large dark surface.
@export var background_navy_bright: Color = Color("#10243A")
## Primarily used for panels, inspectors, navigation regions, and secondary application backgrounds.
@export var background_navy: Color = Color("#081729")
## Primarily used for the main application canvas, window foundation, and deepest uninterrupted workspace areas.
@export var background_navy_dark: Color = Color("#030A14")

func get_background_navy_bright() -> Color:
	return background_navy_bright

func get_background_navy() -> Color:
	return background_navy

func get_background_navy_dark() -> Color:
	return background_navy_dark


@export_group("Theme — Surface Slate")

## Primarily used for hovered cards, raised table rows, active tool panes, and clearly elevated surfaces.
@export var surface_slate_bright: Color = Color("#294258")
## Primarily used for cards, dialogs, data rows, input fields, and panels placed above navy backgrounds.
@export var surface_slate: Color = Color("#1A2D40")
## Primarily used for recessed fields, pressed cards, inset panels, and low-contrast separation between surfaces.
@export var surface_slate_dark: Color = Color("#101E2D")

func get_surface_slate_bright() -> Color:
	return surface_slate_bright

func get_surface_slate() -> Color:
	return surface_slate

func get_surface_slate_dark() -> Color:
	return surface_slate_dark


@export_group("Theme — Border Steel")

## Primarily used for focused outlines, prominent separators, graph-node rims, and high-visibility structural lines.
@export var border_steel_bright: Color = Color("#7896AD")
## Primarily used for normal panel borders, table rules, input outlines, and restrained structural separation.
@export var border_steel: Color = Color("#496579")
## Primarily used for subtle dividers, inactive outlines, background grid lines, and low-priority graph connections.
@export var border_steel_dark: Color = Color("#263D50")

func get_border_steel_bright() -> Color:
	return border_steel_bright

func get_border_steel() -> Color:
	return border_steel

func get_border_steel_dark() -> Color:
	return border_steel_dark

@export_group("Rarity — Common")

## Primarily used for hovered common records and the upper intensity of ordinary, frequently occurring data.
@export var common_bright: Color = Color("#C4CDD4")
## Primarily used for common records, baseline cross-reference density, and neutral item classification.
@export var common: Color = Color("#8998A3")
## Primarily used for subdued common records, low-density indicators, and common classification backgrounds.
@export var common_dark: Color = Color("#53616B")

func get_common_bright() -> Color:
	return common_bright

func get_common() -> Color:
	return common

func get_common_dark() -> Color:
	return common_dark


@export_group("Rarity — Uncommon")

## Primarily used for hovered uncommon records and vivid indicators of above-baseline relevance.
@export var uncommon_bright: Color = Color("#7FCB91")
## Primarily used for uncommon records, modestly connected scripture, and positive above-average density.
@export var uncommon: Color = Color("#4A9F62")
## Primarily used for subdued uncommon records and green classification backgrounds.
@export var uncommon_dark: Color = Color("#28613A")

func get_uncommon_bright() -> Color:
	return uncommon_bright

func get_uncommon() -> Color:
	return uncommon

func get_uncommon_dark() -> Color:
	return uncommon_dark


@export_group("Rarity — Rare")

## Primarily used for hovered rare records and luminous indicators of strongly connected material.
@export var rare_bright: Color = Color("#69B9F0")
## Primarily used for rare records, highly connected scripture, and notable analytical significance.
@export var rare: Color = Color("#347FC4")
## Primarily used for subdued rare records and blue rarity classification backgrounds.
@export var rare_dark: Color = Color("#224C80")

func get_rare_bright() -> Color:
	return rare_bright

func get_rare() -> Color:
	return rare

func get_rare_dark() -> Color:
	return rare_dark


@export_group("Rarity — Epic")

## Primarily used for hovered epic records and luminous indicators of exceptionally dense relationships.
@export var epic_bright: Color = Color("#B994E8")
## Primarily used for epic records, exceptionally connected scripture, and high analytical importance.
@export var epic: Color = Color("#8055B6")
## Primarily used for subdued epic records and violet rarity classification backgrounds.
@export var epic_dark: Color = Color("#4D3275")

func get_epic_bright() -> Color:
	return epic_bright

func get_epic() -> Color:
	return epic

func get_epic_dark() -> Color:
	return epic_dark


@export_group("Rarity — Legendary")

## Primarily used for hovered legendary records and the brightest marker of extraordinary importance.
@export var legendary_bright: Color = Color("#FFD77A")
## Primarily used for legendary records, the most connected scripture, and top-tier analytical importance.
@export var legendary: Color = Color("#E4A93F")
## Primarily used for subdued legendary records and gold rarity classification backgrounds.
@export var legendary_dark: Color = Color("#8B5D1D")

func get_legendary_bright() -> Color:
	return legendary_bright

func get_legendary() -> Color:
	return legendary

func get_legendary_dark() -> Color:
	return legendary_dark


@export_group("Utility — Success")

## Primarily used for hovered success banners, strongly confirmed operations, and completed-state highlights.
@export var success_bright: Color = Color("#70D7A0")
## Primarily used for successful saves, valid states, completed tasks, and affirmative status messages.
@export var success: Color = Color("#32A66A")
## Primarily used for subdued success backgrounds, pressed affirmative controls, and persistent completed states.
@export var success_dark: Color = Color("#1C6843")

func get_success_bright() -> Color:
	return success_bright

func get_success() -> Color:
	return success

func get_success_dark() -> Color:
	return success_dark


@export_group("Utility — Information")

## Primarily used for hovered informational notices, help highlights, and highly visible neutral guidance.
@export var information_bright: Color = Color("#79C9E8")
## Primarily used for informational banners, tips, metadata notices, and non-critical system guidance.
@export var information: Color = Color("#3598BE")
## Primarily used for subdued information backgrounds, persistent hints, and low-priority guidance.
@export var information_dark: Color = Color("#205E78")

func get_information_bright() -> Color:
	return information_bright

func get_information() -> Color:
	return information

func get_information_dark() -> Color:
	return information_dark


@export_group("Utility — Caution")

## Primarily used for hovered caution notices and attention states that do not yet indicate a problem.
@export var caution_bright: Color = Color("#F3DD78")
## Primarily used for unsaved changes, potentially consequential choices, and mild attention messages.
@export var caution: Color = Color("#C6A83E")
## Primarily used for subdued caution backgrounds and persistent low-intensity attention states.
@export var caution_dark: Color = Color("#756321")

func get_caution_bright() -> Color:
	return caution_bright

func get_caution() -> Color:
	return caution

func get_caution_dark() -> Color:
	return caution_dark


@export_group("Utility — Warning")

## Primarily used for hovered warning notices and strong attention before a risky or disruptive action.
@export var warning_bright: Color = Color("#F4AF69")
## Primarily used for risky operations, recoverable problems, degraded states, and disruptive confirmations.
@export var warning: Color = Color("#D4772F")
## Primarily used for subdued warning backgrounds, pressed warning controls, and persistent risk states.
@export var warning_dark: Color = Color("#84451E")

func get_warning_bright() -> Color:
	return warning_bright

func get_warning() -> Color:
	return warning

func get_warning_dark() -> Color:
	return warning_dark


@export_group("Utility — Error")

## Primarily used for hovered error notices, failed-field focus, and highly visible destructive feedback.
@export var error_bright: Color = Color("#F07B7F")
## Primarily used for failures, invalid input, destructive actions, broken states, and blocking messages.
@export var error: Color = Color("#C94F55")
## Primarily used for subdued error backgrounds, pressed destructive controls, and persistent failure states.
@export var error_dark: Color = Color("#7A2C32")

func get_error_bright() -> Color:
	return error_bright

func get_error() -> Color:
	return error

func get_error_dark() -> Color:
	return error_dark


@export_group("Utility — Text Light")

## Primarily used for maximum-emphasis headings, selected text, and text placed over strong dark colors.
@export var text_light_bright: Color = Color("#F5F8FA")
## Primarily used for normal body text, labels, values, and primary reading content on dark surfaces.
@export var text_light: Color = Color("#D8E1E8")
## Primarily used for secondary text, metadata, placeholders, disabled labels, and de-emphasized reading content.
@export var text_light_dark: Color = Color("#9AABB8")

func get_text_light_bright() -> Color:
	return text_light_bright

func get_text_light() -> Color:
	return text_light

func get_text_light_dark() -> Color:
	return text_light_dark


@export_group("Utility — Text Dark")

## Primarily used for softer dark text over bright gold, pale status colors, and light hovered controls.
@export var text_dark_bright: Color = Color("#31404B")
## Primarily used for normal text over light surfaces, bright badges, and pale data visualizations.
@export var text_dark: Color = Color("#18242D")
## Primarily used for maximum-contrast text over luminous accents and the brightest utility backgrounds.
@export var text_dark_dark: Color = Color("#080D12")

func get_text_dark_bright() -> Color:
	return text_dark_bright

func get_text_dark() -> Color:
	return text_dark

func get_text_dark_dark() -> Color:
	return text_dark_dark


@export_group("Utility — Disabled")

## Primarily used for disabled elements that must remain clearly visible against the darkest background.
@export var disabled_bright: Color = Color("#667581")
## Primarily used for disabled controls, unavailable actions, inactive icons, and non-interactive indicators.
@export var disabled: Color = Color("#46545F")
## Primarily used for deeply subdued disabled backgrounds and unavailable elements with minimal prominence.
@export var disabled_dark: Color = Color("#2B353D")

func get_disabled_bright() -> Color:
	return disabled_bright

func get_disabled() -> Color:
	return disabled

func get_disabled_dark() -> Color:
	return disabled_dark


@export_group("Utility — Selection")

## Primarily used for focused selections, active text highlights, and hovered selected rows.
@export var selection_bright: Color = Color("#4DAED8")
## Primarily used for selected rows, selected text, active list items, and current navigation state.
@export var selection: Color = Color("#237AA3")
## Primarily used for unfocused selections, persistent selection backgrounds, and pressed selected items.
@export var selection_dark: Color = Color("#174B68")

func get_selection_bright() -> Color:
	return selection_bright

func get_selection() -> Color:
	return selection

func get_selection_dark() -> Color:
	return selection_dark


@export_group("Monotone — White")

## Primarily used for rare maximum-luminance highlights and accessibility-critical contrast.
@export var white_bright: Color = Color("#FFFFFF")
## Primarily used for crisp light marks, icons, and high-emphasis neutral content.
@export var white: Color = Color("#F0F2F4")
## Primarily used for softened white elements that should not glare against the navy workspace.
@export var white_dark: Color = Color("#D9DEE2")

func get_white_bright() -> Color:
	return white_bright

func get_white() -> Color:
	return white

func get_white_dark() -> Color:
	return white_dark


@export_group("Monotone — Light Gray")

## Primarily used for high-contrast neutral lines, inactive bright icons, and subtle light surface variation.
@export var light_gray_bright: Color = Color("#C5CDD3")
## Primarily used for secondary neutral icons, supporting labels, and light structural elements.
@export var light_gray: Color = Color("#A7B1B9")
## Primarily used for subdued neutral text, inactive markers, and low-emphasis light dividers.
@export var light_gray_dark: Color = Color("#89959E")

func get_light_gray_bright() -> Color:
	return light_gray_bright

func get_light_gray() -> Color:
	return light_gray

func get_light_gray_dark() -> Color:
	return light_gray_dark


@export_group("Monotone — Mid Gray")

## Primarily used for prominent neutral borders, inactive controls, and middle-value data marks.
@export var mid_gray_bright: Color = Color("#75828C")
## Primarily used for standard muted borders, disabled content, and neutral supporting structure.
@export var mid_gray: Color = Color("#5B6770")
## Primarily used for subtle neutral outlines, inactive graph edges, and recessed separators.
@export var mid_gray_dark: Color = Color("#424C54")

func get_mid_gray_bright() -> Color:
	return mid_gray_bright

func get_mid_gray() -> Color:
	return mid_gray

func get_mid_gray_dark() -> Color:
	return mid_gray_dark


@export_group("Monotone — Dark Gray")

## Primarily used for elevated charcoal surfaces and the lightest layer of near-black neutral UI.
@export var dark_gray_bright: Color = Color("#343D44")
## Primarily used for charcoal panels, neutral recessed regions, and dark non-navy components.
@export var dark_gray: Color = Color("#252C32")
## Primarily used for deep charcoal insets, shadows, and near-black neutral separation.
@export var dark_gray_dark: Color = Color("#171C21")

func get_dark_gray_bright() -> Color:
	return dark_gray_bright

func get_dark_gray() -> Color:
	return dark_gray

func get_dark_gray_dark() -> Color:
	return dark_gray_dark


@export_group("Monotone — Black")

## Primarily used for the lightest black layer, deep overlays, and controlled soft shadows.
@export var black_bright: Color = Color("#11161B")
## Primarily used for strong shadows, modal dimming foundations, and near-absolute dark regions.
@export var black: Color = Color("#080B0E")
## Primarily used for maximum-depth shadows and rare absolute-black contrast anchors.
@export var black_dark: Color = Color("#020304")

func get_black_bright() -> Color:
	return black_bright

func get_black() -> Color:
	return black

func get_black_dark() -> Color:
	return black_dark
