module ApplicationHelper
  def highlighted_class(path)
     request.path.include?(path) ? " bg-indigo-50 text-indigo-700" : " text-gray-500 hover:bg-gray-100 hover:text-gray-700"
  end
end
