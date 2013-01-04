Deface::Override.new(:virtual_path => "spree/admin/shared/_order_tabs",
                     :name => "add_events_to_order_tabs",
                     :insert_bottom => "[data-hook='admin_order_tabs']",
                     :text => %q{
                       <li<%== ' class="active"' if current == 'Events' %>>
                         <%= link_to_with_icon 'icon-exclamation-sign', t(:order_events), spree.admin_order_events_url(@order) %>
                       </li>
                     },
                     :disabled => false)
