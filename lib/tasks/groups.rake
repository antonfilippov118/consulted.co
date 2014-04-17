namespace :groups do
  desc 'purge all groups'
  task purge: :environment do
    puts 'purging groups...'
    Group.delete_all
  end
  desc "create initial group structure"
  task seed: [:purge, :environment] do

    def create(group, parent = nil)
      _group = Group.create name: group[:name], description: group[:description], parent: parent

      unless group[:children].nil?
        group[:children].each do |child|
          create child, _group
        end
      end
    end

    groups.each do |group|
      create group
    end
  end

  def groups
    [
      {
        name: 'Finance',
        description: 'Finance',
        children: [
          {
            name: 'Bingo',
            description: 'Stratagems for Bingo and more!',
            children: [
              {
                name: 'Stratagems',
                description: 'Advanced Stratagems for later use'
              },
              {
                name: 'Tactics',
                description: 'Lesser known tactics'
              }
            ]
          },
          {
            name: 'The colourful world of stocks',
            description: 'Stocks and more!',
            children: [
              {
                name: 'Vesting',
                description: 'Gaining shares over time'
              }
            ]
          },
          {
            name: 'Company takeovers',
            description: 'Takeovers - hostile and friendly',
            children: [
              {
                name: 'Hostile',
                description: 'Hostile takeovers made easy'
              },
              {
                name: 'Friendly',
                description: 'Firendly takeovers made hard'
              }
            ]
          }
        ]
      },
      {
        name: 'Functional advice',
        description: 'Functional advice',
        children: [
          {
            name: 'Coporate Finance',
            children: [
              {
                name: 'Branding',
                description: 'Branding',
                children: [
                  {
                    name: 'Insights from the industry',
                    description: 'High quality industry insights on branding'
                  }
                ]
              },
              {
                name: 'Consumer & Shopper insights',
                description: 'Insight into current industry trends',
                children: [
                  {
                    name: 'Customer experience',
                    description: 'Get up to speed with current customer experiences'
                  },
                  {
                    name: 'Customer Lifecycle',
                    description: "Want to know starts and ends of a product?"
                  }
                ]
              },
              {
                name: 'Risk management',
                description: 'Tired of uncalculable risks?',
                children: [
                  {
                    name: 'Calculation',
                    description: 'Advanced risk calculation'
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        name: 'Industry Insights',
        description: 'Industry insights',
        children: [
          {
            name: 'Go-To-Market strategies',
            description: 'Want to get into the market? Look here for advice?'
          }
        ]
      }
    ]
  end
end
