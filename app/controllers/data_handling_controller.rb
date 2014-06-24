class DataHandlingController < ApplicationController
  unloadable
  include SharedModule
  layout 'companies_layout'

  require 'zip/zip'
  require 'zip/zipfilesystem'

  def index

  end

  def full_export
    project = @project
    attachment_hash = get_attachments(project)

    t = Tempfile.new("some-weird-temp-file-basename")
# Give the path of the temp file to the zip outputstream, it won't try to open it as an archive.
    Zip::ZipOutputStream.open(t.path) do |zos|
      attachment_hash.keys.each do |key|
        attachment_hash[key].each do |attachment|
          # Create a new entry with some arbitrary name
          zos.put_next_entry(key + attachment.filename)
          # Add the contents of the file, don't read the stuff linewise if its binary, instead use direct IO
          zos.print IO.read(Rails.root.join('files').to_s + '/' + attachment.disk_directory + '/' + attachment.disk_filename)
        end
        zos.put_next_entry('csv/clients.csv')
        clients = Tempfile.open("clients.csv") do |f|
          f.print(Client.to_csv(@project.clients))
          f.flush
        end
        zos.print IO.read(clients)
        zos.put_next_entry('csv/companies.csv')
        companies = Tempfile.open("companies.csv") do |f|
          f.print(Company.to_csv(@project.companies))
          f.flush
        end
        zos.print IO.read(companies)
        zos.put_next_entry('csv/crm_actions.csv')
        actions = Tempfile.open("crm_actions.csv") do |f|
          f.print(CrmAction.to_csv(@project.crm_actions))
          f.flush
        end
        zos.print IO.read(actions)
        zos.put_next_entry('csv/crm_comments.csv')
        comments = Tempfile.open("crm_comments.csv") do |f|
          f.print(Crmcomment.to_csv(Crmcomment.all))
          f.flush
        end
        zos.print IO.read(comments)
      end
    end
# End of the block  automatically closes the file.
# Send it using the right mime type, with a download window and some nice file name.
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "attachments.zip"
# The temp file will be deleted some time...
    t.close
  end

  private
  def get_attachments(project)
    attachment_hash = {}
    project.clients.each do |client|
      folder_name = project.name + '/' + client.to_s.gsub(', ','_') + '/'
      if attachment_hash[folder_name].present?
        attachment_hash[folder_name] << client.attachments
      else
        attachment_hash[folder_name] = client.attachments
      end
    end
    project.crm_actions.each do |action|
      folder_name = project.name + '/' + action.name + '/'
      if attachment_hash[folder_name].present?
        attachment_hash[folder_name] << action.attachments
      else
        attachment_hash[folder_name] = action.attachments
      end
    end
    return attachment_hash
  end
end
