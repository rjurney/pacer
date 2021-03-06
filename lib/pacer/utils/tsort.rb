require 'tsort'

module Pacer
  module Utils
    module TSort
      module Graph
        def tsort_dependencies_route
          @tsort_dependencies_route ||= proc { |vertices| vertices.in_e.out_v(Pacer::Utils::TSort) }
        end

        def tsort_dependencies_route=(callable)
          @tsort_dependencies_route = callable
        end
      end

      module Route
        include ::TSort

        def tsort_dependencies_route
          return @tsort_dependencies_route if defined? @tsort_dependencies_route
          unless graph.respond_to? :tsort_dependencies_route
            graph.extend Pacer::Utils::TSort::Graph
          end
          @tsort_dependencies_route ||= graph.tsort_dependencies_route
        end

        def tsort_dependencies_route=(callable)
          @tsort_dependencies_route = callable
        end

        def tsort_each_node
          v.each do |vertex|
            yield vertex
          end
        end

        def tsort_each_child(node)
          node.tsort_dependencies.each do |vertex|
            yield vertex
          end
        end
      end

      module Vertex
        def tsort_each_node
          yield self
        end

        def tsort_dependencies
          tsort_dependencies_route.call(self)
        end
      end
    end
  end
end
