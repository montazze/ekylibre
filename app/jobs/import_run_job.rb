# = Informations
#
# == License
#
# Ekylibre - Simple agricultural ERP
# Copyright (C) 2009-2012 Brice Texier, Thibaud Merigon
# Copyright (C) 2012-2014 Brice Texier, David Joulin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.

class ImportRunJob < ActiveJob::Base
  queue_as :default

  def perform(import_id)
    import = Import.find(import_id)
    begin
      import.run
      import.notify(:import_finished_successfully)
    rescue => e
      import.update_columns(state: e.is_a?(Import::InterruptRequest) ? :aborted : :errored)
      import.notify(:import_failed, { message: e.message }, level: :error)
    end
  end
end
