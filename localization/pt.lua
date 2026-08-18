local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'ptBR')
if not L then return end

-- general
L.Add = 'Definir como Lixo'
L.DestroyCheapest = 'Destruir Lixo Mais Barato'
L.DestroyJunk = 'Destruir Lixo'
L.Forget = 'Esquecer'
L.Junk = 'Lixo'
L.JunkList = 'Lista do Lixo'
L.NotJunk = 'Útil'
L.SellJunk = 'Vender Lixo'
L.Remove = 'Definir como Útil'
L.ToggleMousehover = 'Marcar Item Sob o Mouse como Lixo ou Não'

-- chat
L.Added = 'Definido como lixo: %s'
L.Destroyed = 'Você destruiu: %s x %s'
L.Forgotten = 'Definição de ser lixo esquecida: %s'
L.GuildRepaired = 'A sua guilda reparou o seu equipamento por %s'
L.SoldJunk = 'Vendeu seu lixo por %s'
L.Repaired = 'Reparou seu equipamento por %s'
L.Removed = 'Definido como útil: %s'

-- dialogs
L.ConfirmDelete = 'Tem certeza de que deseja destruir todos os seus itens inúteis? Esta ação não pode ser anulada.'

-- options
L.GeneralDescription = 'Estas são funcionalidades gerais que podem ser ativadas ou desativadas de acordo com suas preferências. O lixo não passará!'
L.ListDescription = 'Estas opções permitem que você configure sua lista de lixo e detecção automática de lixo ainda mais.'

L.Behaviour = 'Comportamento'
L.AutoSell = 'Vender Automaticamente'
L.AutoSellTip = 'Se ativado, o Scrap venderá automaticamente todo o lixo quando visitar um comerciante.'
L.AutoRepair = 'Reparar Automaticamente'
L.AutoRepairTip = 'Se ativado, o Scrap irá reparar automaticamente a sua armadura ao visitar um comerciante.'
L.DestroyWorthless = 'Destruir Itens sem Valor'
L.DestroyWorthlessTip = 'Se ativado, o Scrap irá destruir itens inúteis que não têm valor de venda.'
L.GuildRepair = 'Usar Fundos da Guilda'
L.GuildRepairTip = 'Se ativado, o Scrap usará fundos disponíveis da guilda para reparos antes do seu próprio dinheiro.'
L.SafeMode = 'Modo Seguro'
L.SafeModeTip = 'Se ativado, o Scrap não venderá mais de 12 itens de uma só vez, para que você possa sempre comprá-los de volta.'

L.Visuals = 'Visuais'
L.Glow = 'Bordas Brilhantes'
L.GlowTip = 'Se ativado, bordas cinzas brilhantes aparecerão nos seus itens do Scrap.'
L.Icons = 'Ícones de Moeda'
L.IconsTip = 'Se ativado, pequenas moedas de ouro aparecerão nos seus itens do Scrap.'
L.SellPrices = 'Preços na Dica de Ferramenta'
L.SellPricesTip = 'Se ativado, os preços de venda dos itens serão mostrados nas dicas de ferramenta, mesmo quando não estiver em um comerciante.'

L.CharSpecific = 'Específico por Personagem'
L.Learning = 'Otimização Automática'
L.LearningTip = 'Se ativado, o Scrap observará e aprenderá quais itens você geralmente vende para o comerciante e irá marcá-los como lixo automaticamente.'
L.LowConsumable = 'Consumíveis Baixos'
L.LowConsumableTip = 'Se ativado, o Scrap venderá qualquer consumível que seja muito baixo para o seu nível.'
L.LowEquip = 'Equipamento Baixo'
L.LowEquipTip = 'Se ativado, o Scrap venderá qualquer equipamento vinculado à alma que tenha um valor muito menor do que o que você está usando.'
L.Unusable = 'Equipamento Inutilizável'
L.UnusableTip = 'Se ativado, o Scrap venderá qualquer equipamento vinculado à alma que nunca poderia ser usado pelo seu personagem.'
L.iLevelTreshold = 'Limite de Nível de Item'
L.EquipLevelTip = 'Controla o nível de item abaixo do qual os itens são considerados lixo, com base em uma porcentagem do nível do seu equipamento atual.|n|nPor exemplo: a 100%, qualquer item abaixo do seu nível equipado é lixo; a 50%, apenas itens abaixo da metade desse nível são.'
L.ConsumableLevelTip = 'Controla o nível de item abaixo do qual os consumíveis são considerados lixo, calculado como uma porcentagem do nível do seu personagem.'

-- help
L.PatronsDescription = 'O Scrap é distribuído gratuitamente e mantido por doações. Um enorme obrigado a todos os apoiadores no Patreon e Paypal que mantêm o desenvolvimento ativo. Você também pode se tornar um patrono em |cFFF96854patreon.com/jaliborc|r.'
L.HelpDescription = 'Aqui fornecemos respostas para as perguntas mais frequentes. Também recomendamos seguir o tutorial no jogo. Se nenhum dos dois resolver o seu problema, você pode pedir ajuda na comunidade de usuários do Scrap no Discord.'

L.FAQ = {
	'Como adicionar/remover um item da lista de lixo?',
	'Existem várias maneiras:|n1) A mais simples é arrastar o item para o botão do Scrap ao visitar um comerciante (ao lado dos botões de reparo de armadura).|n2) Você pode configurar um atalho em Menu do Jogo -> Teclado -> Scrap -> "Marcar Item Sob o Mouse como Lixo ou Não". Em seguida, passe o mouse sobre os itens no inventário e pressione o atalho para alternar o status de lixo.|n3) Você pode gerenciar os itens que adicionou ou removeu na aba do Scrap na parte inferior do painel do comerciante (ao lado da aba Recomprar).',
	'O ícone do Scrap não está aparecendo sobre os itens no Bagnon!',
	'Essa funcionalidade não faz parte do núcleo do Scrap, faz parte de um plugin separado. Tente instalar ou atualizar o |cffffd200Bagnon Scrap Support|r.'
}

-- tutorials
L.Tutorial_Welcome = 'Bem-vindo ao |cffffd200Scrap|r, a solução inteligente de venda de lixo por |cffffd200Jaliborc|r. Este pequeno tutorial irá ajudá-lo a começar a vender seu lixo.|n|nIsso economizará seu tempo, e suas bolsas certamente agradecerão. Vamos começar?'
L.Tutorial_Button = 'O Scrap venderá automaticamente todo o seu lixo sempre que você visitar um comerciante. Mas você pode vendê-lo manualmente: basta clicar com o |cffffd200Botão Esquerdo|r no botão do Scrap.|n|nClique com o |cffffd200Botão Direito|r no botão para ver opções adicionais.'
L.Tutorial_Drag = 'E se você quiser dizer ao Scrap quais itens vender ou não? Basta |cffffd200Arrastar|r o item da sua bolsa para o botão do Scrap.|n|nAlternativamente, você pode definir um |cffffd200Atalho|r nas opções do |cffffd200Menu do Jogo|r. Pressione-o enquanto passa o mouse sobre o item.'
L.Tutorial_Visualizer = 'Para ver quais itens você especificou como lixo ou não, abra a aba do |cffffd200Visualizador de Scrap|r.|n|nNote que ele só exibirá os itens que você |cffffd200especificou|r, não todos os itens no jogo.'
L.Tutorial_Bye = 'Boa sorte em suas jornadas, e que os |cffb400ffÉpicos|r estejam com você. O lixo não passará!'
