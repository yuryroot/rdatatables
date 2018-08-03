RSpec.describe 'html generation' do

  context '#build_header_html' do
    let(:table) do
      Class.new(RDataTables::Table).tap do |table|
        table.column :id
        table.column :first_name
        table.column :last_name
        table.column :email
        table.column :country
        table.column :city
        table.column :phone,     if_func: -> { true  }
        table.column :ignore_me, if_func: -> { false }
        table.column :actions, sortable: false, searchable: false
      end
    end

    context 'without extra options' do
      let(:html) do
        table.new.build_header_html
      end

      it 'generates expected HTML' do
        expect(html).to have_tag('thead tr') do
          with_tag 'th', count: 8
          without_tag 'th', text: 'ignore_me'

          with_tag 'th', text: 'id',         with: { 'data-sortable' => true,  'data-searchable' => true  }
          with_tag 'th', text: 'first_name', with: { 'data-sortable' => true,  'data-searchable' => true  }
          with_tag 'th', text: 'last_name',  with: { 'data-sortable' => true,  'data-searchable' => true  }
          with_tag 'th', text: 'email',      with: { 'data-sortable' => true,  'data-searchable' => true  }
          with_tag 'th', text: 'country',    with: { 'data-sortable' => true,  'data-searchable' => true  }
          with_tag 'th', text: 'city',       with: { 'data-sortable' => true,  'data-searchable' => true  }
          with_tag 'th', text: 'phone',      with: { 'data-sortable' => true,  'data-searchable' => true  }
          with_tag 'th', text: 'actions',    with: { 'data-sortable' => false, 'data-searchable' => false }
        end
      end

      it 'columns keep order in generated HTML' do
        parsed_html = Nokogiri::HTML(html)
        ordered_headers_text = parsed_html.css('thead th').map(&:text)

        expect(ordered_headers_text).to eq(%w[id first_name last_name email country city phone actions])
      end
    end

    context 'with extra options' do
      let(:html) do
        table.new.build_header_html do |builder|
          builder.id class: 'id', title: 'Click to check all' do
            '<input type="checkbox" class="js-select-all">'
          end

          builder.first_name class: 'first-name', title: 'First name' do
            'First name'
          end

          builder.last_name class: 'last-name', title: 'Last name' do
            'Last name'
          end

          builder.email class: 'email', title: 'Email' do
            '<span class="bold-text">Email address</span>'
          end

          builder.country class: 'country', title: 'Country' do
            'Country'
          end

          builder.city class: 'city', title: 'City' do
            'City'
          end

          builder.phone class: 'phone', title: 'Phone' do
            'Phone'
          end

          builder.actions class: 'actions', title: 'Actions', style: "background: red;" do
            'Actions'
          end
        end
      end

      it 'generates expected HTML' do
        expect(html).to have_tag('thead tr') do
          with_tag 'th', count: 8
          without_tag 'th', text: 'ignore_me'

          with_tag 'th',
            with: { 'class' => 'id', 'title' => 'Click to check all', 'data-sortable' => true, 'data-searchable' => true } do
            with_tag 'input', with: { 'type' => 'checkbox', 'class' => 'js-select-all' }
          end

          with_tag 'th',
            text: 'First name',
            with: { 'class' => 'first-name', 'title' => 'First name', 'data-sortable' => true, 'data-searchable' => true }

          with_tag 'th',
            text: 'Last name',
            with: { 'class' => 'last-name', 'title' => 'Last name', 'data-sortable' => true, 'data-searchable' => true }

          with_tag 'th',
            with: { 'class' => 'email', 'title' => 'Email', 'data-sortable' => true, 'data-searchable' => true } do
            with_tag 'span', text: 'Email address', with: { 'class' => 'bold-text' }
          end

          with_tag 'th',
            text: 'Country',
            with: { 'class' => 'country', 'title' => 'Country', 'data-sortable' => true, 'data-searchable' => true }

          with_tag 'th',
            text: 'City',
            with: { 'class' => 'city', 'title' => 'City', 'data-sortable' => true, 'data-searchable' => true }

          with_tag 'th',
            text: 'Phone',
            with: { 'class' => 'phone', 'title' => 'Phone', 'data-sortable' => true, 'data-searchable' => true }

          with_tag 'th',
            text: 'Actions',
            with: { 'class' => 'actions', 'title' => 'Actions', 'data-sortable' => false, 'data-searchable' => false, 'style' => 'background: red;' }
        end
      end

      it 'columns keep order in generated HTML' do
        parsed_html = Nokogiri::HTML(html)
        ordered_headers_titles = parsed_html.css('thead th').map { |th|  th.attributes['title'].to_s }

        expect(ordered_headers_titles).to eq(["Click to check all", "First name", "Last name", "Email", "Country", "City", "Phone", "Actions"])
      end
    end
  end
end
