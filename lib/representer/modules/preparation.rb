module Representer
  module Modules
    module Preparation

      ##
      # Go through the representable and prepare a Hash which will be passed
      # to serialization
      #
      def prepare
        before_prepare
        prepared = @representable.collect { |item| first_pass(item) }
        prepared = after_prepare(prepared)
        load_aggregates

        run_second_pass prepared
        prepared = after_second_pass(prepared)
        finalize prepared
      end

      ##
      # Method called before the first pass and any extraction
      #
      def before_prepare
      end

      ##
      # Check whether the @representable is a collection of not
      #
      # It memoizes the value unless it is nil
      #
      # @return Boolean
      def collection?
        return @is_collection unless @is_collection.nil?
        @is_collection = @representable.is_a?(Array) ||
                         @representable.is_a?(ActiveRecord::Relation)
      end

      ##
      # Loop through the second pass unless it should be skipped
      #
      def run_second_pass(prepared)
        prepared.each { |item| second_pass(item) } unless skip_second_pass?
      end

      ##
      # Returns whether we should we skip the second pass
      #
      # @return Boolean
      def skip_second_pass?
        self.class.representable_fields.size == 0
      end

      ##
      # When wrapping up, make sure we don't return an array
      # if it's not a collection
      def finalize(prepared)
        collection? ? prepared : prepared[0]
      end

      ##
      # Callback called after first pass is complete
      #
      # @param Array prepared - array of extracted hashes
      #
      def after_prepare(prepared)
        prepared
      end
      alias :after_first_pass :after_prepare

      ##
      # Callback called after the second pass is complete and before finalizing
      #
      def after_second_pass(prepared)
        prepared
      end

    end
  end
end
