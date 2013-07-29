Deface::Override.new(:virtual_path => "spree/admin/shared/_order_tabs",
                     :name => "add_notifications_to_order_tabs",
                     :insert_bottom => "[data-hook='admin_order_tabs']",
                     :text => %q{
                       <li<%== ' class="active"' if current == 'Notifications' %>>
                         <%= link_to t(:order_notifications), spree.admin_order_notifications_url(@order) %>
                       </li>
                     },
                     :disabled => false)
