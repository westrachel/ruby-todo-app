class SessionPersistence
	def initialize(session)
		@session = session
		@session[:lists] ||= []
	end

	def find_list(id)
		@session[:lists].find { |l| l[:id] == id }
	end

  def all_lists
    @session[:lists] 
  end

  def add_new_list(name)
    id = next_available_id(@session[:lists])
    @session[:lists] << { id: id, name: list_name, todos: []}
  end

  def delete_list(id)
    @session[:lists].reject! { |list| list[:id] == id }
  end

  def revise_list_name(id, new_name)
    list = find_list(id)
    list[:name] = new_name
  end

  def create_new_todo(list_id, todo_name)
    list = find_list(list_id)
    id = next_available_id(list[:todos])
    list[:todos] << { id: id, name: todo_name, completed: false }
  end

  def delete_todo_from_list(list_id, todo_id)
    list = find_list(list_id)
    list[:todos].reject! { |todo| todo[:id] == todo_id }
  end

  def mark_all_todos_as_completed(list_id)
    list = find_list(list_id)
    list[:todos].each { |todo| todo[:completed] = true }
  end

  def update_todo_status(list_id, todo_id, new_status)
    list = find_list(list_id)
    todo = list[:todos].find { |t| t[:id] == todo_id }
    todo[:completed] = new_status
  end

  private

  def all_ids(list)
    list.map { |element| element[:id] }
  end

  def next_available_id(list)
    all_ids(list).empty? ? 0 : (current_ids.max + 1)
  end
end