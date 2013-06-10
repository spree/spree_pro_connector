module Samples
  module Order
    extend self

    def persist
      {
        message: "order:persist",
        payload: Samples.order
      }
    end

    def ship
      {
        message: "order:ship",
        payload: {
          shipment_number: "H54306587582",
          order: {
            actual: Samples.order
          }
        }
      }
    end

    def capture
      actual, current = Samples.orders
      {
        message: "order:capture",
        payload: {
          payment: {
            id: 16258,
            amount: "260.82",
            state: "pending",
            payment_method_id: 931422127,
            payment_method: {
              id: 931422127,
              name: "Credit Card",
              environment: "production"
            }
          },
          order: {
            actual:  actual,
            current: current
          }
        }
      }
    end

    def payment_captured
      actual, current = Samples.orders
      {
        message: "order:payment:captured",
        payload: {
          payment: { id: 16258 },
          order: {
            actual:  actual,
            current: current
          }
        }
      }
    end
  end
end

