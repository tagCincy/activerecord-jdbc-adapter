require 'arel/visitors/compat'

module Arel
  module Visitors
    class Derby < Arel::Visitors::ToSql
      def visit_Arel_Nodes_SelectStatement o
        [
         o.cores.map { |x| visit(x) }.join,
         ("ORDER BY #{o.orders.map { |x| visit x }.join(', ')}" unless o.orders.empty?),
         (visit(o.limit) if o.limit),
         (visit(o.offset) if o.offset),
         (visit(o.lock) if o.lock),
        ].compact.join ' '
      end

      def visit_Arel_Nodes_Limit o
        "FETCH FIRST #{limit_for(o)} ROWS ONLY"
      end

      def visit_Arel_Nodes_Offset o
        "OFFSET #{visit o.value} ROWS"
      end
    end
  end
end
