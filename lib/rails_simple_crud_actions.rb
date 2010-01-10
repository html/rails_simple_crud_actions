module Actions
  module Repository
    define_action :index do
      str = self.class.to_s.sub /Controller$/, ''
      var =  "@#{str.underscore.pluralize}"
      model = str.singularize.camelize.constantize

      instance_variable_set var, model.all

      respond_to do |format|
        format.html
        format.xml { render :xml => instance_variable_get(var) }
      end
    end

    define_action :new do
      str = self.class.to_s.sub /Controller$/, ''
      var =  "@#{str.underscore.singularize}"
      model = str.singularize.camelize.constantize

      instance_variable_set var, model.new
      
      respond_to do |format|
        format.html
        format.xml { render :xml => instance_variable_get(var) }
      end
    end

    define_action :edit do
      str = self.class.to_s.sub /Controller$/, ''
      var =  "@#{str.underscore.singularize}"
      model = str.singularize.camelize.constantize

      instance_variable_set var, model.find(params[:id])
    end

    define_action :show do
      str = self.class.to_s.sub /Controller$/, ''
      var =  "@#{str.underscore.singularize}"
      model = str.singularize.camelize.constantize

      instance_variable_set var, model.find(params[:id])
      respond_to do |format|
        format.html
        format.xml { render :xml => instance_variable_get(var) }
      end
    end

    define_action :create do
      str = self.class.to_s.sub /Controller$/, ''
      var =  "@#{str.underscore.singularize}"
      model = str.singularize.camelize.constantize

      item = model.new(params[str.underscore.singularize])
      instance_variable_set(var, item)

      respond_to do |format|
        if item.save
          flash[:notice] = str.camelize + ' was successfully created.'
          format.html { redirect_to(item) }
          format.xml  { render :xml => item, :status => :created, :location => item }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
        end
      end
    end

    define_action :destroy do
      str = self.class.to_s.sub /Controller$/, ''
      var =  "@#{str.underscore.singularize}"
      model = str.singularize.camelize.constantize

      item = model.find(params[:id])
      item.destroy

      respond_to do |format|
        format.html { redirect_to(eval("#{str.underscore.pluralize}_url")) }
        format.xml  { head :ok }
      end
    end

    define_action :update do
      str = self.class.to_s.sub /Controller$/, ''
      var =  "@#{str.underscore.singularize}"
      model = str.singularize.camelize.constantize

      instance_variable_set var, (item = model.find(params[:id]))

      respond_to do |format|
        if item.update_attributes(params[str.underscore.singularize])
          flash[:notice] = str.camelize + ' was successfully updated.'
          format.html { redirect_to(item) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
end
