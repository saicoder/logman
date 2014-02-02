

# Sample query
# created_at > 5, type="some type"
class Logman
  class QueryBuilder
      attr_accessor :con
      
      def initialize(con)
        @con = con
      end
      
      
      def execute(param)
        str = URI.decode(param)
        obj = JSON.parse(str)
        
        obj.each do |q|
          build_concern(q)  
        end
        
        @con
      end
      
      private
      
      def build_concern(q)
        return if q['property'].blank? || q['operator'].blank?
        q['property'] = '_id' if q['property'] == 'id' 
        
        
        @con = @con.where(q['property'].to_sym => q['value']) if q['operator'] == '='
        @con = @con.where(q['property'].to_sym => Regexp.compile(".*#{q['value']}.*")) if q['operator'] == '~'
        
        
        operator_map = {
          '<'=> "$lt",
          '<='=> "$lte",
          '>'=> "$gt",
          '>='=> "$gte"
        }
        
        oper = operator_map[q['operator']]
        if oper
          @con = @con.selector[q['property']] = {oper => q['value']}
        end
        
      end
      
  end
end