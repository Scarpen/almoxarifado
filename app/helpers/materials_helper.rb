module MaterialsHelper

	def can_destroy?(material)
		material.status == 1 ? false : true
	end

	def log(version)
		material_version = version.reify
		version.next ? next_version = version.next.reify : next_version = version.material
		username = version.user.username
		log = I18n.l(version.created_at, format: "%a às %R") + " - O usuário '" + username

		if version.event == "update"
			if next_version.name == material_version.name
				quantity = next_version.quantity - material_version.quantity
				log << "' deu "
				quantity > 0 ? log << "entrada " : log << "saida "
				log << "no material '" + material_version.name + "' em " + quantity.to_s
				log << " ficando com "+ next_version.quantity.to_s + " unidade(s) em estoque. \n"
				return Hash[str: log, op: 'qnt']
			else
				log << "' alterou o nome do material "
				log << material_version.name + " para '" + next_version.name + "'. \n"
				return Hash[str: log, op: 'name']
			end
		elsif version.event == "create"
				log << "' criou o material '"
				next_version ? log << next_version.name : log << version.material.name
				log << "'. \n"
				return Hash[str: log, op: 'new']
		end
	end

end
