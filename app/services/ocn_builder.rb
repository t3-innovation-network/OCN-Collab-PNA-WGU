# frozen_string_literal: true

# Builds an OCN graph from CSV data
class OCNBuilder
  def initialize(data:)
    @data = data
  end

  def build_competency(row:)
    {
      id: row[0],
      type: 'Competency',
      containedIn: 'ec25f820-0dbc-4cc3-80ef-1fa699f8c90b',
      competencyLabel: { 'en-us': row[1] },
      competencyText: { 'en-us': row[3] },
      competencyCategory: { 'en-us': row[4] },
      dataURL: row[0],
      htmlURL: row[0],
      keywords: (row[5]&.split(';') || []).map { { 'en-us': _1.strip } },
      contextualizedBy: extract_codes(rows: [row])
    }
  end

  def build_contextualizing_object(code:)
    {
      id: code,
      type: 'Occupation',
      category: [{
        type: 'CategoryCode',
        codeValue: code,
        inCodeSet: 'https://www.onetonline.org/'
      }]
    }
  end

  def competencies
    @competencies ||=
      rows.each_with_index.map do |row, index|
        build_competency(row:)
      rescue StandardError => e
        raise "Row ##{index} -- #{e.message}"
      end
  end

  def container
    {
      id: 'ec25f820-0dbc-4cc3-80ef-1fa699f8c90b',
      type: 'Collection',
      fromDirectory: '196b55f1-9f65-4d66-8f8a-cee14000dcd7',
      dataURL: 'https://www.wgu.edu/lp/general/wgu/skills-library.html',
      htmlURL: 'https://www.wgu.edu/lp/general/wgu/skills-library.html',
      name: { 'en-us': 'WGU Rich Skill Descriptors' },
      description: { 'en-us': description },
      attributionName: { 'en-us': 'Western Governors University' },
      attributionURL: 'https://www.wgu.edu/',
      beneficiaryRights: 'The WGU Skills libraries are made available under a Creative Commons BY-SA 4.0.',
      providerMetaModel: 'https://ocf-collab.org/concepts/4e47f526-0003-4c4a-9cbf-91e23bc53704',
      registryRights: 'https://www.ocf-collab.org/rights/b2656920-5c58-4942-8915-a1e6d883f86c'
    }
  end

  def contextualizing_objects
    @contextualizing_objects ||= extract_codes(rows:).map do |code|
      {
        id: code,
        type: 'Occupation',
        category: [{
          type: 'CategoryCode',
          codeValue: code,
          inCodeSet: 'https://www.onetonline.org/'
        }]
      }
    end
  end

  def directory
    {
      id: '196b55f1-9f65-4d66-8f8a-cee14000dcd7',
      type: 'Directory',
      name: { 'en-us': 'Western Governors University (WGU)' }
    }
  end

  def graph
    {
      directory:,
      container:,
      competencies:,
      contextualizingObjects: contextualizing_objects
    }
  end

  private

  def description
    'The WGU Skills Library is an open resource of structured skills data leveraged to promote a more equitable ' \
      'skills-driven hiring and education ecosystem that enables all learners, workers, and employers to have the ' \
      'skills and talent necessary to thrive in a fast-moving and ever-evolving workforce. We use our skills library ' \
      'as a foundation for designing competencies and credentials at WGU to ensure that our programs, courses, and ' \
      'assessments are aligned with current and projected labor market demand.'
  end

  def extract_codes(rows:)
    codes = rows.map do |row|
      row
        .values_at(8, 9, 10, 11)
        .flat_map { _1&.split(';') || [] }
        .map(&:strip)
    end

    codes.flatten.uniq
  end

  def rows
    @rows ||= CSV.parse(@data, headers: true)
  end
end
