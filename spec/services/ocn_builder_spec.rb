# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OCNBuilder do
  let(:builder) { OCNBuilder.new(data: File.read(path)) }
  let(:competencies) { builder.competencies }
  let(:container) { builder.container }
  let(:contextualizing_objects) { builder.contextualizing_objects }
  let(:directory) { builder.directory }
  let(:path) { FIXTURES_PATH.join('wgu_data.csv') }

  describe '#competencies' do
    let(:competency1) { competencies.first }
    let(:competency2) { competencies.last }

    it 'builds competencies' do
      expect(competencies.size).to eq(2)

      expect(competency1.keys).to eq(%i[id type containedIn competencyLabel competencyText competencyCategory dataURL
                                        htmlURL keywords contextualizedBy])
      expect(competency2.keys).to eq(%i[id type containedIn competencyLabel competencyText competencyCategory dataURL
                                        htmlURL keywords contextualizedBy])

      expect(competency1[:competencyCategory]).to eq({ 'en-us': 'Patient/Family Education' })
      expect(competency1[:competencyLabel]).to eq({ 'en-us': 'Patient Communication Coaching' })
      expect(competency1[:competencyText]).to eq({ 'en-us': 'Coach patients appropriately considering ' \
                                                            'communication barriers.' })
      expect(competency1[:containedIn]).to eq('ec25f820-0dbc-4cc3-80ef-1fa699f8c90b')
      expect(competency1[:contextualizedBy]).to eq(%w[31-0000	31-9000	31-9090	31-9092])
      expect(competency1[:dataURL]).to eq('https://osmt.wgu.edu/api/skills/859926d7-996c-4178-9ce0-786c7db145c3')
      expect(competency1[:id]).to eq('https://osmt.wgu.edu/api/skills/859926d7-996c-4178-9ce0-786c7db145c3')
      expect(competency1[:htmlURL]).to eq('https://osmt.wgu.edu/api/skills/859926d7-996c-4178-9ce0-786c7db145c3')
      expect(competency1[:keywords]).to eq([
                                             { 'en-us': 'Medical Assistant' },
                                             { 'en-us': 'Patient/Family Education' },
                                             { 'en-us': 'Patient/Family Education and Instruction' },
                                             { 'en-us': 'WGUSID: 928' }
                                           ])
      expect(competency1[:type]).to eq('Competency')

      expect(competency2[:competencyCategory]).to eq({ 'en-us': 'Patient/Family Education' })
      expect(competency2[:competencyLabel]).to eq({ 'en-us': 'Patient Cultural Diversity Coaching' })
      expect(competency2[:competencyText]).to eq({ 'en-us': 'Coach patients appropriately considering cultural ' \
                                                            'diversity.' })
      expect(competency2[:containedIn]).to eq('ec25f820-0dbc-4cc3-80ef-1fa699f8c90b')
      expect(competency2[:contextualizedBy]).to eq(%w[31-9000	31-9094])
      expect(competency2[:dataURL]).to eq('https://osmt.wgu.edu/api/skills/45cdbf6e-9544-4cf2-8c35-70a60626b2e7')
      expect(competency2[:id]).to eq('https://osmt.wgu.edu/api/skills/45cdbf6e-9544-4cf2-8c35-70a60626b2e7')
      expect(competency2[:htmlURL]).to eq('https://osmt.wgu.edu/api/skills/45cdbf6e-9544-4cf2-8c35-70a60626b2e7')
      expect(competency2[:keywords]).to eq([])
      expect(competency2[:type]).to eq('Competency')
    end
  end

  describe '#container' do
    let(:description) do
      'The WGU Skills Library is an open resource of structured skills data leveraged to promote a more equitable ' \
        'skills-driven hiring and education ecosystem that enables all learners, workers, and employers to have the ' \
        'skills and talent necessary to thrive in a fast-moving and ever-evolving workforce. We use our skills ' \
        'library as a foundation for designing competencies and credentials at WGU to ensure that our programs, ' \
        'courses, and assessments are aligned with current and projected labor market demand.'
    end

    it 'builds a container' do
      expect(container.keys).to eq(%i[id type fromDirectory dataURL htmlURL name description attributionName
                                      attributionURL beneficiaryRights providerMetaModel registryRights])
      expect(container[:attributionName]).to eq({ 'en-us': 'Western Governors University' })
      expect(container[:attributionURL]).to eq('https://www.wgu.edu/')
      expect(container[:beneficiaryRights]).to eq('The WGU Skills libraries are made available under ' \
                                                  'a Creative Commons BY-SA 4.0.')
      expect(container[:dataURL]).to eq('https://www.wgu.edu/lp/general/wgu/skills-library.html')
      expect(container[:description]).to eq({ 'en-us': description })
      expect(container[:fromDirectory]).to eq('196b55f1-9f65-4d66-8f8a-cee14000dcd7')
      expect(container[:id]).to eq('ec25f820-0dbc-4cc3-80ef-1fa699f8c90b')
      expect(container[:htmlURL]).to eq('https://www.wgu.edu/lp/general/wgu/skills-library.html')
      expect(container[:name]).to eq({ 'en-us': 'WGU Rich Skill Descriptors' })
      expect(container[:providerMetaModel]).to eq('https://ocf-collab.org/concepts/4e47f526-0003-4c4a-9cbf-91e23bc53704')
      expect(container[:registryRights]).to eq('https://www.ocf-collab.org/rights/b2656920-5c58-4942-8915-a1e6d883f86c')
      expect(container[:type]).to eq('Collection')
    end
  end

  describe '#contextualizing_objects' do
    let(:contextualizing_object1) { contextualizing_objects[0] }
    let(:contextualizing_object2) { contextualizing_objects[1] }
    let(:contextualizing_object3) { contextualizing_objects[2] }
    let(:contextualizing_object4) { contextualizing_objects[3] }
    let(:contextualizing_object5) { contextualizing_objects[4] }

    it 'builds contextualizing objects' do
      expect(contextualizing_objects.size).to eq(5)

      expect(contextualizing_object1[:id]).to eq('31-0000')
      expect(contextualizing_object1[:type]).to eq('Occupation')
      expect(contextualizing_object1[:category]).to eq([{
                                                         type: 'CategoryCode',
                                                         codeValue: '31-0000',
                                                         inCodeSet: 'https://www.onetonline.org/'
                                                       }])

      expect(contextualizing_object2[:id]).to eq('31-9000')
      expect(contextualizing_object2[:type]).to eq('Occupation')
      expect(contextualizing_object2[:category]).to eq([{
                                                         type: 'CategoryCode',
                                                         codeValue: '31-9000',
                                                         inCodeSet: 'https://www.onetonline.org/'
                                                       }])

      expect(contextualizing_object3[:id]).to eq('31-9090')
      expect(contextualizing_object3[:type]).to eq('Occupation')
      expect(contextualizing_object3[:category]).to eq([{
                                                         type: 'CategoryCode',
                                                         codeValue: '31-9090',
                                                         inCodeSet: 'https://www.onetonline.org/'
                                                       }])

      expect(contextualizing_object4[:id]).to eq('31-9092')
      expect(contextualizing_object4[:type]).to eq('Occupation')
      expect(contextualizing_object4[:category]).to eq([{
                                                         type: 'CategoryCode',
                                                         codeValue: '31-9092',
                                                         inCodeSet: 'https://www.onetonline.org/'
                                                       }])

      expect(contextualizing_object5[:id]).to eq('31-9094')
      expect(contextualizing_object5[:type]).to eq('Occupation')
      expect(contextualizing_object5[:category]).to eq([{
                                                         type: 'CategoryCode',
                                                         codeValue: '31-9094',
                                                         inCodeSet: 'https://www.onetonline.org/'
                                                       }])
    end
  end

  describe '#directory' do
    it 'builds a directory' do
      expect(directory.keys).to eq(%i[id type name])
      expect(directory[:id]).to eq('196b55f1-9f65-4d66-8f8a-cee14000dcd7')
      expect(directory[:name]).to eq({ 'en-us': 'Western Governors University (WGU)' })
      expect(directory[:type]).to eq('Directory')
    end
  end

  describe '#graph' do
    it 'builds a graph' do
      expect(builder.graph).to eq({
                                    directory:,
                                    container:,
                                    competencies:,
                                    contextualizingObjects: contextualizing_objects
                                  })
    end
  end
end
